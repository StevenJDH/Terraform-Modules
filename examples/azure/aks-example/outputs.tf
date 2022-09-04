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

output "public_aks_resource_group_id" {
  value = module.public_aks.resource_group_id
}

output "public_aks_cluster_id" {
  value = module.public_aks.cluster_id
}

output "public_aks_secondary_node_pool" {
  value = module.public_aks.secondary_node_pool
}

output "public_aks_client_key" {
  value = module.public_aks.client_key
  sensitive = true
}

output "public_aks_client_certificate" {
  value = module.public_aks.client_certificate
  sensitive = true
}

output "public_aks_cluster_ca_certificate" {
  value = module.public_aks.cluster_ca_certificate
  sensitive = true
}

output "public_aks_kube_config" {
  value = module.public_aks.kube_config
  sensitive = true
}

output "public_aks_oidc_issuer_url" {
  value = module.public_aks.oidc_issuer_url
}

output "public_aks_cluster_username" {
  value = module.public_aks.cluster_username
  sensitive = true
}

output "public_aks_cluster_password" {
  value = module.public_aks.cluster_password
  sensitive = true
}

output "public_aks_host" {
  value = module.public_aks.host
  sensitive = true
}

output "public_aks_fqdn" {
  value = module.public_aks.fqdn
}

output "public_aks_ssh_private_key" {
  value     = module.public_aks.ssh_private_key
  sensitive = true
}

output "public_aks_ssh_private_key_storage_blob_id" {
  value = module.public_aks.ssh_private_key_storage_blob_id
}

output "public_aks_ssh_private_key_storage_blob_url" {
  value = module.public_aks.ssh_private_key_storage_blob_url
}

output "public_aks_log_analytics_workspace_id" {
  value = module.public_aks.log_analytics_workspace_id
}

output "public_aks_kubeconfig_cmd" {
  value = module.public_aks.kubeconfig_cmd
}

output "private_aks_resource_group_id" {
  value = module.private_aks.resource_group_id
}

output "private_aks_cluster_id" {
  value = module.private_aks.cluster_id
}

output "private_aks_secondary_node_pool" {
  value = module.private_aks.secondary_node_pool
}

output "private_aks_client_key" {
  value = module.private_aks.client_key
  sensitive = true
}

output "private_aks_client_certificate" {
  value = module.private_aks.client_certificate
  sensitive = true
}

output "private_aks_cluster_ca_certificate" {
  value = module.private_aks.cluster_ca_certificate
  sensitive = true
}

output "private_aks_kube_config" {
  value = module.private_aks.kube_config
  sensitive = true
}

output "private_aks_oidc_issuer_url" {
  value = module.private_aks.oidc_issuer_url
}

output "private_aks_cluster_username" {
  value = module.private_aks.cluster_username
  sensitive = true
}

output "private_aks_cluster_password" {
  value = module.private_aks.cluster_password
  sensitive = true
}

output "private_aks_host" {
  value = module.private_aks.host
  sensitive = true
}

output "private_aks_fqdn" {
  value = module.private_aks.fqdn
}

output "private_aks_ssh_private_key" {
  value     = module.private_aks.ssh_private_key
  sensitive = true
}

output "private_aks_ssh_private_key_storage_blob_id" {
  value = module.private_aks.ssh_private_key_storage_blob_id
}

output "private_aks_ssh_private_key_storage_blob_url" {
  value = module.private_aks.ssh_private_key_storage_blob_url
}

output "private_aks_log_analytics_workspace_id" {
  value = module.private_aks.log_analytics_workspace_id
}

output "private_aks_kubeconfig_cmd" {
  value = module.private_aks.kubeconfig_cmd
}