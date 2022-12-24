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

module "eks-fargate-cwl-logs" {
  source = "../../../aws/eks-fargate-logging"

  cluster_name                           = data.aws_eks_cluster.selected.name
  private_fargate_worker_node_subnet_ids = data.aws_eks_cluster.selected.vpc_config[0].subnet_ids
  eks_fargate_role_name                  = "eks-fargate-role-${replace(data.aws_eks_cluster.selected.name, "eks-", "")}"
  cloudwatch_log_retention_in_days       = 7
  region                                 = var.region

  tags = local.tags
}