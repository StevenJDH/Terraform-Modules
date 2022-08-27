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

resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = local.is_gateway_lb ? local.gateway_lb_service_name : var.service_name
  private_dns_enabled = var.enable_private_dns
  ip_address_type     = var.ip_address_type
  subnet_ids          = var.subnet_ids
  route_table_ids     = var.route_table_ids
  security_group_ids  = var.security_group_ids
  vpc_endpoint_type   = var.vpc_endpoint_type

  dynamic "dns_options" {
    for_each = var.enable_private_dns ? [true] : []

    content {
      dns_record_ip_type = var.dns_record_ip_type
    }
  }

  lifecycle {
    ignore_changes = [security_group_ids,]
  }

  tags = merge(
    { Name = format("vpce-%s", var.name) },
    var.tags,
    var.vpce_tags,
  )
}

resource "aws_vpc_endpoint_service" "gateway-lb" {
  count = local.is_gateway_lb && var.service_name == null ? 1 : 0

  acceptance_required        = false
  allowed_principals         = [data.aws_caller_identity.current[0].arn]
  gateway_load_balancer_arns = var.gateway_load_balancer_arns

  tags = merge(
    { Name = format("vpce-svc-%s", var.name) },
    var.tags,
    var.vpce_svc_tags,
  )
}