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

output "simple_eks_vpc_arn" {
  value = module.simple-eks.vpc_arn
}

output "simple_eks_vpc_id" {
  value = module.simple-eks.vpc_id
}

output "simple_eks_vpc_default_route_table_id" {
  value = module.simple-eks.vpc_default_route_table_id
}

output "simple_eks_vpc_main_route_table_id" {
  value = module.simple-eks.vpc_main_route_table_id
}

output "simple_eks_vpc_default_network_acl_id" {
  value = module.simple-eks.vpc_default_network_acl_id
}

output "simple_eks_vpc_default_security_group_id" {
  value = module.simple-eks.vpc_default_security_group_id
}

output "simple_eks_subnet_info" {
  value = module.simple-eks.subnet_info
}

output "simple_eks_route_table_private_ids" {
  value = module.simple-eks.route_table_private_ids
}

output "simple_eks_route_table_private_arns" {
  value = module.simple-eks.route_table_private_arns
}

output "simple_eks_route_table_gateway_ids" {
  value = module.simple-eks.route_table_gateway_ids
}

output "simple_eks_route_table_gateway_arns" {
  value = module.simple-eks.route_table_gateway_arns
}

output "simple_eks_eip_public_nat_ids" {
  value = module.simple-eks.eip_public_nat_ids
}

output "simple_eks_public_nat_ids" {
  value = module.simple-eks.public_nat_ids
}

output "simple_eks_internet_gateway_id" {
  value = module.simple-eks.internet_gateway_id
}

output "simple_eks_internet_gateway_arn" {
  value = module.simple-eks.internet_gateway_arn
}

output "simple_eks_api_server_endpoint" {
  value = module.simple-eks.api_server_endpoint
}

output "simple_eks_platform_version" {
  value = module.simple-eks.platform_version
}

output "simple_eks_cluster_security_group_id" {
  value = module.simple-eks.cluster_security_group_id
}

output "simple_eks_kubeconfig_certificate_authority_data" {
  value = module.simple-eks.kubeconfig_certificate_authority_data
}

output "simple_eks_addon_info" {
  value = module.simple-eks.addon_info
}

output "simple_eks_node_group_ids" {
  value = module.simple-eks.node_group_ids
}

output "simple_eks_node_group_arns" {
  value = module.simple-eks.node_group_arns
}

output "simple_eks_ssh_key_pair_name" {
  value = module.simple-eks.ssh_key_pair_name
}

output "simple_eks_ssh_private_key" {
  value = module.simple-eks.ssh_public_key
  sensitive = true
}

output "simple_eks_ssh_public_key" {
  value = module.simple-eks.ssh_public_key
}

output "simple_eks_ssh_private_key_s3_bucket_key" {
  value = module.simple-eks.ssh_private_key_s3_bucket_key
}

output "simple_eks_cloudwatch_log_group_id" {
  value = module.simple-eks.cloudwatch_log_group_id
}

output "simple_eks_cloudwatch_log_group_arn" {
  value = module.simple-eks.cloudwatch_log_group_arn
}

output "simple_eks_cloudwatch_log_group_name" {
  value = module.simple-eks.cloudwatch_log_group_name
}

output "simple_eks_node_role_id" {
  value = module.simple-eks.eks_node_role_id
}

output "simple_eks_node_role_arn" {
  value = module.simple-eks.eks_node_role_arn
}

output "simple_eks_node_role_name" {
  value = module.simple-eks.eks_node_role_name
}

output "simple_eks_cluster_role_id" {
  value = module.simple-eks.eks_cluster_role_id
}

output "simple_eks_cluster_role_arn" {
  value = module.simple-eks.eks_cluster_role_arn
}

output "simple_eks_cluster_role_name" {
  value = module.simple-eks.eks_cluster_role_name
}

output "simple_eks_cluster_oidc_issuer_url" {
  value = module.simple-eks.eks_cluster_oidc_issuer_url
}

output "simple_eks_kubeconfig_cmd" {
  value = module.simple-eks.kubeconfig_cmd
}

output "custom_eks_vpc_arn" {
  value = module.custom-eks.vpc_arn
}

output "custom_eks_vpc_id" {
  value = module.custom-eks.vpc_id
}

output "custom_eks_vpc_default_route_table_id" {
  value = module.custom-eks.vpc_default_route_table_id
}

output "custom_eks_vpc_main_route_table_id" {
  value = module.custom-eks.vpc_main_route_table_id
}

output "custom_eks_vpc_default_network_acl_id" {
  value = module.custom-eks.vpc_default_network_acl_id
}

output "custom_eks_vpc_default_security_group_id" {
  value = module.custom-eks.vpc_default_security_group_id
}

output "custom_eks_subnet_info" {
  value = module.custom-eks.subnet_info
}

output "custom_eks_route_table_private_ids" {
  value = module.custom-eks.route_table_private_ids
}

output "custom_eks_route_table_private_arns" {
  value = module.custom-eks.route_table_private_arns
}

output "custom_eks_route_table_gateway_ids" {
  value = module.custom-eks.route_table_gateway_ids
}

output "custom_eks_route_table_gateway_arns" {
  value = module.custom-eks.route_table_gateway_arns
}

output "custom_eks_eip_public_nat_ids" {
  value = module.custom-eks.eip_public_nat_ids
}

output "custom_eks_public_nat_ids" {
  value = module.custom-eks.public_nat_ids
}

output "custom_eks_internet_gateway_id" {
  value = module.custom-eks.internet_gateway_id
}

output "custom_eks_internet_gateway_arn" {
  value = module.custom-eks.internet_gateway_arn
}

output "custom_eks_api_server_endpoint" {
  value = module.custom-eks.api_server_endpoint
}

output "custom_eks_platform_version" {
  value = module.custom-eks.platform_version
}

output "custom_eks_cluster_security_group_id" {
  value = module.custom-eks.cluster_security_group_id
}

output "custom_eks_kubeconfig_certificate_authority_data" {
  value = module.custom-eks.kubeconfig_certificate_authority_data
}

output "custom_eks_addon_info" {
  value = module.custom-eks.addon_info
}

output "custom_eks_node_group_ids" {
  value = module.custom-eks.node_group_ids
}

output "custom_eks_node_group_arns" {
  value = module.custom-eks.node_group_arns
}

output "custom_eks_ssh_key_pair_name" {
  value = module.custom-eks.ssh_key_pair_name
}

output "custom_eks_ssh_private_key" {
  value = module.custom-eks.ssh_public_key
  sensitive = true
}

output "custom_eks_ssh_public_key" {
  value = module.custom-eks.ssh_public_key
}

output "custom_eks_ssh_private_key_s3_bucket_key" {
  value = module.custom-eks.ssh_private_key_s3_bucket_key
}

output "custom_eks_cloudwatch_log_group_id" {
  value = module.custom-eks.cloudwatch_log_group_id
}

output "custom_eks_cloudwatch_log_group_arn" {
  value = module.custom-eks.cloudwatch_log_group_arn
}

output "custom_eks_cloudwatch_log_group_name" {
  value = module.custom-eks.cloudwatch_log_group_name
}

output "custom_eks_node_role_id" {
  value = module.custom-eks.eks_node_role_id
}

output "custom_eks_node_role_arn" {
  value = module.custom-eks.eks_node_role_arn
}

output "custom_eks_node_role_name" {
  value = module.custom-eks.eks_node_role_name
}

output "custom_eks_cluster_role_id" {
  value = module.custom-eks.eks_cluster_role_id
}

output "custom_eks_cluster_role_arn" {
  value = module.custom-eks.eks_cluster_role_arn
}

output "custom_eks_cluster_role_name" {
  value = module.custom-eks.eks_cluster_role_name
}

output "custom_eks_cluster_oidc_issuer_url" {
  value = module.custom-eks.eks_cluster_oidc_issuer_url
}

output "custom_eks_kubeconfig_cmd" {
  value = module.custom-eks.kubeconfig_cmd
}