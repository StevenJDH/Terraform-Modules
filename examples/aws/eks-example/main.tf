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

module "simple-eks" {
  source = "../../../aws/eks"

  cluster_name = "simple-example-cluster-${local.stage}"

  tags = local.tags
}

module "custom-eks" {
  source = "../../../aws/eks"

  cluster_name                     = "custom-example-cluster-${local.stage}"
  kubernetes_version               = "1.23"
  eks_subnet_configuration         = local.eks_subnet_configuration
  eks_node_group_config            = local.eks_node_group_config
  enable_cluster_log_types         = ["api", "audit"]
  cloudwatch_log_retention_in_days = 7
  endpoint_private_access          = true
  endpoint_public_access           = true
  public_access_cidrs              = ["0.0.0.0/0"]
  service_ipv4_cidr                = "172.20.0.0/16"
  enable_node_ssh_access           = true

  tags = local.tags
}