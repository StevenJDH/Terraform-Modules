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

module "vnet-with-subnets" {
  source = "../../../azure/vnet"

  name                  = "vnet-example-${local.stage}"
  create_resource_group = true
  resource_group_name   = "rg-vnet-example-${local.stage}"
  location              = var.location
  address_space         = "10.0.0.0/16"
  subnet_configuration  = local.subnet_config

  tags = local.tags
}