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

output "private_dns_zone_id" {
  value = try(azurerm_private_dns_zone.this[0].id, "")
}

output "private_dns_a_record_id" {
  value = try(azurerm_private_dns_a_record.this[0].id, "")
}

output "public_dns_zone_id" {
  value = try(azurerm_dns_zone.this[0].id, "")
}

output "public_dns_a_record_id" {
  value = try(azurerm_dns_a_record.this[0].id, "")
}