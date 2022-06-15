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

output "private_resource_group_id" {
  value = module.private-dns-a-record.resource_group_id
}

output "private_dns_zone_id" {
  value = module.private-dns-a-record.private_dns_zone_id
}

output "private_dns_a_record_id" {
  value = module.private-dns-a-record.private_dns_a_record_id
}

output "public_resource_group_id" {
  value = module.public-dns-a-record.resource_group_id
}

output "public_dns_zone_id" {
  value = module.public-dns-a-record.public_dns_zone_id
}

output "public_dns_a_record_id" {
  value = module.public-dns-a-record.public_dns_a_record_id
}