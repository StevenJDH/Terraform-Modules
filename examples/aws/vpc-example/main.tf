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

module "vpc-example" {
  source = "../../../aws/vpc"

  name                                = "network-example-${local.stage}"
  enable_ipv6                         = true
  create_egress_only_internet_gateway = true
  create_internet_gateway             = true
  single_private_route_table          = true
  single_public_route_table           = true
  subnet_configuration                = local.subnet_config

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}