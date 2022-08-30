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

output "vpc_arn" {
  value = module.vpc-example.vpc_arn
}

output "vpc_id" {
  value = module.vpc-example.vpc_id
}

output "vpc_default_route_table_id" {
  value = module.vpc-example.vpc_default_route_table_id
}

output "vpc_main_route_table_id" {
  value = module.vpc-example.vpc_main_route_table_id
}

output "vpc_default_network_acl_id" {
  value = module.vpc-example.vpc_default_network_acl_id
}

output "vpc_default_security_group_id" {
  value = module.vpc-example.vpc_default_security_group_id
}

output "vpc_ipv6_association_id" {
  value = module.vpc-example.vpc_ipv6_association_id
}

output "subnet_ids_and_address_info" {
  value = module.vpc-example.subnet_ids_and_address_info
}

output "route_table_private_ids" {
  value = module.vpc-example.route_table_private_ids
}

output "route_table_private_arns" {
  value = module.vpc-example.route_table_private_arns
}

output "route_table_private_gateway_ids" {
  value = module.vpc-example.route_table_private_gateway_ids
}

output "route_table_private_gateway_arns" {
  value = module.vpc-example.route_table_private_gateway_arns
}

output "route_table_gateway_ids" {
  value = module.vpc-example.route_table_gateway_ids
}

output "route_table_gateway_arns" {
  value = module.vpc-example.route_table_gateway_arns
}

output "private_nat_ids" {
  value = module.vpc-example.private_nat_ids
}

output "eip_public_nat_ids" {
  value = module.vpc-example.eip_public_nat_ids
}

output "public_nat_ids" {
  value = module.vpc-example.public_nat_ids
}

output "internet_gateway_id" {
  value = module.vpc-example.internet_gateway_id
}

output "internet_gateway_arn" {
  value = module.vpc-example.internet_gateway_arn
}

output "egress_only_internet_gateway_id" {
  value = module.vpc-example.egress_only_internet_gateway_id
}