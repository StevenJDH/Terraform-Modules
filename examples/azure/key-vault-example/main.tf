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

resource "random_string" "this" {
  length           = 5
  special          = false
  upper            = false
}

module "public-key-vault" {
  source = "../../../azure/key-vault"

  key_vault_name        = "kv-example-${random_string.this.id}-${local.stage}"
  create_resource_group = true
  resource_group_name   = "rg-key-vault-example-${local.stage}"
  access_policies       = local.access_policies
  location              = var.location

  tags = local.tags
}

module "private-key-vault" {
  source = "../../../azure/key-vault"

  key_vault_name        = "kv-example2-${random_string.this.id}-${local.stage}"
  create_resource_group = true
  resource_group_name   = "rg-key-vault-example2-${local.stage}"
  access_policies       = local.access_policies
  location              = var.location

  network_acls                      = local.network_acls
  create_private_endpoint           = true
  subnet_endpoint_id                = data.azurerm_subnet.example.id
  create_private_dns_resource_group = true
  private_dns_resource_group_name   = "rg-example2-${local.stage}"
  create_private_dns_zone           = true
  create_private_dns_record         = true
  create_private_dns_zone_vnet_link = true
  virtual_network_id                = data.azurerm_virtual_network.example.id

  tags = local.tags
}