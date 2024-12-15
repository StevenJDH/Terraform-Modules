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
  subnet_tags =  {
    cluster = "kubernetes.io/cluster/eks-${var.cluster_name}"
  }

  subnet_ids = tolist([
    for v in module.vpc-eks.subnet_ids_and_address_info : v.id
  ])

  subnet_configuration = [for e in var.eks_subnet_configuration: {
    subnet_name               = null
    new_bits                  = e.new_bits
    availability_zone         = e.availability_zone
    make_public               = e.make_public
    create_nat_gateway        = e.create_nat_gateway
  }]

  worker_nodes_subnet_indexes = tolist([
    for idx, v in var.eks_subnet_configuration : idx if v.allow_worker_nodes
  ])

  worker_nodes_subnet_ids = [for idx in local.worker_nodes_subnet_indexes : element(local.subnet_ids, idx)]

  # Doing this here so same information can be checked by coredns patch for Fargate.
  eks_cluster_addons = tomap({
    for addon in var.eks_cluster_addons : addon.name => addon
  })

  fargate_worker_nodes_subnet_indexes = tolist([
    for idx, v in var.eks_subnet_configuration : idx if v.allow_worker_nodes && !v.make_public
  ])

  fargate_worker_nodes_subnet_ids = [for idx in local.fargate_worker_nodes_subnet_indexes : element(local.subnet_ids, idx)]
  fargate_namespaces              = var.enable_fargate_only ? setunion(["kube-system", "default"], var.fargate_namespaces) : var.fargate_namespaces
  apply_fargate_coredns_patch     = contains(keys(local.eks_cluster_addons), "coredns") && contains(local.fargate_namespaces, "kube-system")
}