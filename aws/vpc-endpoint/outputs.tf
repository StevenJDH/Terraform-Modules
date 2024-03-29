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

output "vpce_arn" {
  value = aws_vpc_endpoint.this.arn
}

output "vpce_id" {
  value = aws_vpc_endpoint.this.id
}

output "gateway_lb_vpce_svc_id" {
  value = try(aws_vpc_endpoint_service.gateway-lb[0].id, null)
}

output "gateway_lb_vpce_svc_arn" {
  value = try(aws_vpc_endpoint_service.gateway-lb[0].arn, null)
}

output "gateway_lb_vpce_svc_name" {
  value = try(aws_vpc_endpoint_service.gateway-lb[0].service_name, null)
}