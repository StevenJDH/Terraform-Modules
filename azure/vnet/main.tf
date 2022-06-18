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

resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  address_space       = [var.address_space]
  dns_servers         = var.dns_servers

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  count = length(var.subnet_configuration)

  name                 = var.subnet_configuration[count.index].subnet_name
  resource_group_name  = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.address_space, var.subnet_configuration[count.index].new_bits, count.index)]
  service_endpoints    = var.subnet_configuration[count.index].service_endpoints
}

resource "azurerm_subnet_nat_gateway_association" "example" {
  for_each = tomap({
    for k, v in var.subnet_configuration : k => v.nat_gateway_id if v.nat_gateway_id != null
  })

  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = each.value
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = tomap({
    for k, v in var.subnet_configuration : k => v.network_security_group_id if v.network_security_group_id != null
  })

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = tomap({
    for k, v in var.subnet_configuration : k => v.route_table_id if v.route_table_id != null
  })

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value
}