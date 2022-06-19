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

output "public_key_vault_resource_group_id" {
  value = module.public-key-vault.resource_group_id
}

output "public_key_vault_id" {
  value = module.public-key-vault.key_vault_id
}

output "public_key_vault_uri" {
  value = module.public-key-vault.key_vault_uri
}

output "private_key_vault_resource_group_id" {
  value = module.private-key-vault.resource_group_id
}

output "private_key_vault_id" {
  value = module.private-key-vault.key_vault_id
}

output "private_key_vault_uri" {
  value = module.private-key-vault.key_vault_uri
}

output "privatelink_resource_group_id" {
  value = module.private-key-vault.privatelink_resource_group_id
}

output "privatelink_dns_zone_id" {
  value = module.private-key-vault.privatelink_dns_zone_id
}

output "privatelink_dns_a_record_id" {
  value = module.private-key-vault.privatelink_dns_a_record_id
}

output "private_endpoint_ip_address" {
  value = module.private-key-vault.private_endpoint_ip_address
}