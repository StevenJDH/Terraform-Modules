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

output "cognitive_id" {
  value = azurerm_cognitive_account.this.id
}

output "service_endpoint" {
  value = azurerm_cognitive_account.this.endpoint
}

output "primary_access_key" {
  value = azurerm_cognitive_account.this.primary_access_key
  sensitive = true
}

output "secondary_access_key" {
  value = azurerm_cognitive_account.this.secondary_access_key
  sensitive = true
}

output "private_endpoint_ip_address" {
  value = try(azurerm_private_endpoint.this[0].private_service_connection[0].private_ip_address, "")
}