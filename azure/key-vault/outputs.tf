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

output "resource_group_id" {
  value = try(azurerm_resource_group.this[0].id, "")
}

output "vault_id" {
  value = azurerm_key_vault.this.id
}

output "vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}

output "private_endpoint_ip_address" {
  value = try(azurerm_private_endpoint.this[0].private_service_connection[0].private_ip_address, "")
}

output "privatelink_resource_group_id" {
  value = try(module.privatelink-dns-record[0].resource_group_id, "")
}

output "privatelink_dns_zone_id" {
  value = try(module.privatelink-dns-record[0].private_dns_zone_id, "")
}

output "privatelink_dns_a_record_id" {
  value = try(module.privatelink-dns-record[0].private_dns_a_record_id, "")
}