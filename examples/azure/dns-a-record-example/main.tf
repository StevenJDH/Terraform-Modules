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

module "private-dns-a-record" {
  source = "../../../azure/dns-a-record"

  dns_zone_name                     = "example.com"
  dns_a_record_name                 = "test"
  ip_address_for_a_record           = "10.55.55.55"
  location                          = var.location
  create_resource_group             = true
  resource_group_name               = "rg-private-dns-a-record-example-${local.stage}"
  create_dns_zone                   = true
  create_private_dns_zone_vnet_link = true
  virtual_network_id                = data.azurerm_virtual_network.example.id

  tags = local.tags
}

module "public-dns-a-record" {
  source = "../../../azure/dns-a-record"

  private_dns_record      = false
  dns_zone_name           = "example.com"
  dns_a_record_name       = "test"
  ip_address_for_a_record = "99.55.55.55"
  location                = var.location
  create_resource_group   = true
  resource_group_name     = "rg-public-dns-a-record-example-${local.stage}"
  create_dns_zone         = true

  tags = local.tags
}