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

locals {
  public_subnets = keys(tomap({
    for k, v in var.subnet_configuration : k => v if v.make_public
  }))

  private_subnets = keys(tomap({
    for k, v in var.subnet_configuration : k => v if !v.make_public
  }))

  create_private_rt_tables               = !var.single_private_route_table && length(local.private_subnets) > 0 && length(local.private_subnet_nats) == 0
  create_default_private_rt_entries      = var.add_default_routes && var.single_private_route_table && length(local.public_subnet_nats) == 1
  create_private_rt_entries              = var.add_default_routes && length(local.public_subnet_nats) > 0 && local.create_private_rt_tables
  create_ipv6_private_rt_entries         = var.enable_ipv6 && var.add_default_routes && !var.single_private_route_table && var.create_egress_only_internet_gateway
  create_default_ipv6_private_rt_entries = var.enable_ipv6 && var.add_default_routes && var.single_private_route_table && var.create_egress_only_internet_gateway
  zone_suffixes                          = ["a", "b", "c"]
  igw_will_be_created                    = var.create_internet_gateway || length(local.public_subnet_nats) > 0
  gateway_default_routes_count           = var.single_public_route_table && length(local.public_subnets) > 0 ? 1 : length(local.public_subnets)

  private_subnet_nats = keys(tomap({
    for k, v in var.subnet_configuration : k => v if v.create_nat_gateway && !v.make_public
  }))

  public_subnet_nats = keys(tomap({
    for k, v in var.subnet_configuration : k => v if v.create_nat_gateway && v.make_public
  }))
}