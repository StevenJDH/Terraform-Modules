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
  value = aws_vpc.this.arn
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_default_route_table_id" {
  value = aws_vpc.this.default_route_table_id
}

output "vpc_main_route_table_id" {
  value = aws_vpc.this.main_route_table_id
}

output "vpc_default_network_acl_id" {
  value = aws_vpc.this.default_network_acl_id
}

output "vpc_default_security_group_id" {
  value = aws_vpc.this.default_security_group_id
}

output "vpc_ipv6_association_id" {
  value = aws_vpc.this.ipv6_association_id
}

output "subnet_ids_and_address_info" {
  value = tomap({
    for subnet in flatten([for e in aws_subnet.this.* : [for s in e : s]]) :
      subnet.id => {
        arn             = subnet.arn,
        ipv4_cidr_block = subnet.cidr_block,
        subnet_mask     = cidrnetmask(subnet.cidr_block),
        ipv6_cidr_block = subnet.ipv6_cidr_block
      }
  })
}

output "route_table_private_gateway_ids" {
  value = try(aws_route_table.private-gateway[*].id, null)
}

output "route_table_private_gateway_arns" {
  value = try(aws_route_table.private-gateway[*].arn, null)
}

output "route_table_gateway_ids" {
  value = try(aws_route_table.gateway[*].id, null)
}

output "route_table_gateway_arns" {
  value = try(aws_route_table.gateway[*].arn, null)
}

output "private_nat_ids" {
  value = try(aws_nat_gateway.private[*].id, null)
}

output "eip_public_nat_ids" {
  value = try(aws_eip.nat[*].id, null)
}

output "public_nat_ids" {
  value = try(aws_nat_gateway.public[*].id, null)
}

output "internet_gateway_id" {
  value = try(aws_internet_gateway.this[0].id, null)
}

output "internet_gateway_arn" {
  value = try(aws_internet_gateway.this[0].arn, null)
}

output "egress_only_internet_gateway_id" {
  value = try(aws_egress_only_internet_gateway.this[0].id, null)
}