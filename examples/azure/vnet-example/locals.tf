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
  stage = "dev"

  subnet_config = [
    {
      subnet_name               = "snet-example1"
      new_bits                  = 8
      service_endpoints         = ["Microsoft.KeyVault"]
      nat_gateway_id            = null
      network_security_group_id = null
      route_table_id            = null
    },
    {
      subnet_name               = "snet-example2"
      new_bits                  = 8
      nat_gateway_id            = null
      network_security_group_id = null
      route_table_id            = null
    },
  ]

  tags = {
    environment = local.stage
    terraform   = true
  }
}