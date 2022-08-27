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

module "vpce-interface-example" {
  source = "../../../aws/vpc-endpoint"

  name               = "ssm-vpce-example-${local.stage}"
  vpc_id             = data.aws_vpc.selected.id
  service_name       = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [data.aws_subnet.selected.id,]

  tags = local.tags
}

module "vpce-gateway-lb-example" {
  source = "../../../aws/vpc-endpoint"

  name                       = "gateway-lb-vpce-example-${local.stage}"
  vpc_id                     = data.aws_vpc.selected.id
  vpc_endpoint_type          = "GatewayLoadBalancer"
  subnet_ids                 = [data.aws_subnet.selected.id,]
  gateway_load_balancer_arns = [data.aws_lb.selected-gateway-lb.arn,]

  tags = local.tags
}