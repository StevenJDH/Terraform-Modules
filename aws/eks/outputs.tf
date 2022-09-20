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

output "vpc_arn" {
  value = module.vpc-eks.vpc_arn
}

output "vpc_id" {
  value = module.vpc-eks.vpc_id
}

output "vpc_default_route_table_id" {
  value = module.vpc-eks.vpc_default_route_table_id
}

output "vpc_main_route_table_id" {
  value = module.vpc-eks.vpc_main_route_table_id
}

output "vpc_default_network_acl_id" {
  value = module.vpc-eks.vpc_default_network_acl_id
}

output "vpc_default_security_group_id" {
  value = module.vpc-eks.vpc_default_security_group_id
}

output "subnet_info" {
  value = tolist([
    for k, subnet in module.vpc-eks.subnet_ids_and_address_info :
      {
        id                   = subnet.id,
        arn                  = subnet.arn,
        ipv4_cidr_block      = subnet.ipv4_cidr_block,
        subnet_mask          = subnet.subnet_mask,
        worker_nodes_allowed = var.eks_subnet_configuration[k].allow_worker_nodes
      }
  ])
}

output "route_table_private_ids" {
  value = module.vpc-eks.route_table_private_ids
}

output "route_table_private_arns" {
  value = module.vpc-eks.route_table_private_arns
}

output "route_table_gateway_ids" {
  value = module.vpc-eks.route_table_gateway_ids
}

output "route_table_gateway_arns" {
  value = module.vpc-eks.route_table_gateway_arns
}

output "eip_public_nat_ids" {
  value = module.vpc-eks.eip_public_nat_ids
}

output "public_nat_ids" {
  value = module.vpc-eks.public_nat_ids
}

output "internet_gateway_id" {
  value = module.vpc-eks.internet_gateway_id
}

output "internet_gateway_arn" {
  value = module.vpc-eks.internet_gateway_arn
}

output "api_server_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "platform_version" {
  value = aws_eks_cluster.this.platform_version
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "addon_info" {
  value = tomap({
    for k, v in aws_eks_addon.this : k =>
      {
        id            = v.id,
        arn           = v.arn,
        addon_version = v.addon_version
      }
  })
}

output "node_group_ids" {
  value = aws_eks_node_group.this[*].id
}

output "node_group_arns" {
  value = aws_eks_node_group.this[*].arn
}

output "ssh_key_pair_name" {
  value = try(aws_key_pair.this[0].key_name, null)
}

output "ssh_private_key" {
  value = try(tls_private_key.ssh[0].private_key_pem, null)
  sensitive = true
}

output "ssh_public_key" {
  value = try(tls_private_key.ssh[0].public_key_openssh, null)
}

output "ssh_private_key_s3_bucket_key" {
  value = try(aws_s3_object.ssh-key-pair[0].key, null)
}

output "cloudwatch_log_group_id" {
  value = aws_cloudwatch_log_group.this.id
}

output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.this.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}

output "eks_node_role_id" {
  value = aws_iam_role.eks-node.id
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks-node.arn
}

output "eks_node_role_name" {
  value = aws_iam_role.eks-node.name
}

output "eks_cluster_role_id" {
  value = aws_iam_role.eks-cluster.id
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks-cluster.arn
}

output "eks_cluster_role_name" {
  value = aws_iam_role.eks-cluster.name
}

output "eks_cluster_oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "kubeconfig_cmd" {
  value = "aws eks update-kubeconfig --region ${data.aws_region.current.name} --name eks-${var.cluster_name}"
}