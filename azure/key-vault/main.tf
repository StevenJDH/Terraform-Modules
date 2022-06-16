/*
 * This file is part of Terraform-Modules <https://github.com/StevenJDH/Terraform-Modules>.
 * Copyright (C) 2022 Steven Jenkins De Haro.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 1 : 0

  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_key_vault" "this" {
  name                            = lower(var.key_vault_name)
  location                        = var.create_resource_group ? azurerm_resource_group.this[0].location : var.location
  resource_group_name             = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.enable_purge_protection
  sku_name                        = var.sku_name

  dynamic network_acls {
    for_each = var.network_acls == null ? [] : [true]

    content {
      bypass                     = var.network_acls.bypass_network_acls ? "AzureServices" : "None"
      default_action             = var.network_acls.allow_when_no_acl_rules_match ? "Allow" : "Deny"
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = setunion(var.network_acls.virtual_network_subnet_ids, [var.subnet_endpoint_id])
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "this" {
  for_each = var.access_policies

  key_vault_id        = azurerm_key_vault.this.id
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = each.key

  certificate_permissions = each.value.certificate_permissions
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  storage_permissions     = each.value.storage_permissions
}

resource "azurerm_private_endpoint" "this" {
  count = var.create_private_endpoint ? 1 : 0

  name                = "${var.key_vault_name}-pe"
  location            = var.create_resource_group ? azurerm_resource_group.this[0].location : var.location
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  subnet_id           = var.subnet_endpoint_id

  private_service_connection {
    name                           = "${var.key_vault_name}-psc"
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags
}

module "privatelink-dns-record" {
  source = "../dns-a-record"
  count  = var.create_private_dns_record ? 1 : 0

  private_dns_record                = true
  create_dns_zone                   = var.create_private_dns_zone
  dns_zone_name                     = "privatelink.vaultcore.azure.net"
  dns_a_record_name                 = var.key_vault_name
  ip_address_for_a_record           = azurerm_private_endpoint.this[0].private_service_connection[0].private_ip_address
  location                          = var.location
  create_resource_group             = var.create_private_dns_resource_group
  resource_group_name               = var.private_dns_resource_group_name
  create_private_dns_zone_vnet_link = var.create_private_dns_zone_vnet_link
  enable_auto_registration          = var.enable_auto_registration
  virtual_network_id                = var.virtual_network_id
  ttl                               = var.ttl

  tags = var.tags
}