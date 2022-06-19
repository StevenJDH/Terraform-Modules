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

output "public_resource_group_id" {
  value = module.public_cognitive_tts.resource_group_id
}

output "public_cognitive_id" {
  value = module.public_cognitive_tts.cognitive_id
}

output "public_service_endpoint" {
  value = module.public_cognitive_tts.service_endpoint
}

output "public_primary_access_key" {
  value = module.public_cognitive_tts.primary_access_key
  sensitive = true
}

output "public_secondary_access_key" {
  value = module.public_cognitive_tts.secondary_access_key
  sensitive = true
}

output "private_resource_group_id" {
  value = module.private_cognitive_tts.resource_group_id
}

output "private_cognitive_id" {
  value = module.private_cognitive_tts.cognitive_id
}

output "private_service_endpoint" {
  value = module.private_cognitive_tts.service_endpoint
}

output "private_primary_access_key" {
  value = module.private_cognitive_tts.primary_access_key
  sensitive = true
}

output "private_secondary_access_key" {
  value = module.private_cognitive_tts.secondary_access_key
  sensitive = true
}

output "private_endpoint_ip_address" {
  value = module.private_cognitive_tts.private_endpoint_ip_address
}