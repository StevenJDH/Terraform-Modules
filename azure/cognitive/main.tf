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

resource "azurerm_cognitive_account" "this" {
  name                  = var.name
  location              = var.create_resource_group ? azurerm_resource_group.this[0].location : var.location
  resource_group_name   = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  kind                  = var.kind
  sku_name              = var.sku_name
  custom_subdomain_name = var.custom_subdomain_name

  public_network_access_enabled = var.enable_public_or_selected_network_access

  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [true]

    content {
      default_action = var.network_acls.allow_when_no_acl_rules_match ? "Allow" : "Deny"
      ip_rules = var.network_acls.ip_rules

      dynamic "virtual_network_rules" {
        for_each = var.network_acls.subnet_id_for_service_rules == null ? [] : [true]

        content {
          subnet_id = var.network_acls.subnet_id_for_service_rules
          ignore_missing_vnet_service_endpoint = false
        }
      }
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "this" {
  count = var.create_private_endpoint ? 1 : 0

  name                = "${var.name}-pe"
  location            = var.create_resource_group ? azurerm_resource_group.this[0].location : var.location
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  subnet_id           = var.network_acls.subnet_id_for_service_rules

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_cognitive_account.this.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  tags = var.tags
}