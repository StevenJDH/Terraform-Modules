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

resource "azurerm_private_dns_zone" "this" {
  count = var.create_dns_zone && var.private_dns_record ? 1 : 0

  name                = var.dns_zone_name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "this" {
  count = var.private_dns_record ? 1 : 0

  name                = var.dns_a_record_name
  zone_name           = var.create_dns_zone ? azurerm_private_dns_zone.this[0].name : data.azurerm_private_dns_zone.current[0].name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  ttl                 = var.ttl
  records             = [var.ip_address_for_a_record]

  tags = var.tags
}

resource "azurerm_dns_zone" "this" {
  count = var.create_dns_zone && !var.private_dns_record ? 1 : 0

  name                = var.dns_zone_name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name

  tags = var.tags
}

resource "azurerm_dns_a_record" "this" {
  count = !var.private_dns_record ? 1 : 0

  name                = var.dns_a_record_name
  zone_name           = var.create_dns_zone ? azurerm_dns_zone.this[0].name : data.azurerm_dns_zone.current[0].name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  ttl                 = var.ttl
  records             = [var.ip_address_for_a_record]

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count = var.create_dns_zone && var.private_dns_record && var.create_private_dns_zone_vnet_link ? 1 : 0

  name                  = format("vnet-%s-link", replace(var.dns_zone_name, ".", "-"))
  resource_group_name   = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[0].name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = var.enable_auto_registration

  tags = var.tags
}