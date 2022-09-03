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
  aws_profile = "default"

  eks_subnet_configuration = [
    {
      new_bits                  = 8
      availability_zone         = "a"
      make_public               = true
      create_nat_gateway        = true
      allow_worker_nodes        = false
    },
    {
      new_bits                  = 8
      availability_zone         = "a"
      make_public               = false
      create_nat_gateway        = false
      allow_worker_nodes        = true
    },
    {
      new_bits                  = 8
      availability_zone         = "b"
      make_public               = true
      create_nat_gateway        = true
      allow_worker_nodes        = false
    },
    {
      new_bits                  = 8
      availability_zone         = "b"
      make_public               = false
      create_nat_gateway        = false
      allow_worker_nodes        = true
    },
  ]

  eks_node_group_config = [
    {
      prefix                 = "minion-"
      instance_type          = "t3.micro"
      capacity_type          = "ON_DEMAND"
      disk_size              = 5
      labels                 = {}
      scaling_desired_size   = 1
      scaling_max_size       = 1
      scaling_min_size       = 1
      taints                 = []
      update_max_unavailable = 1
    },
  ]

  tags = {
    environment = local.stage
    terraform   = true
  }
}