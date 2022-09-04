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

output "resource_group_id" {
  value = try(azurerm_resource_group.this[0].id, null)
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "secondary_node_pool" {
  value = azurerm_kubernetes_cluster_node_pool.this[*].id
}

output "client_key" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "oidc_issuer_url" {
  value = var.enable_oidc_issuer ? azurerm_kubernetes_cluster.this.oidc_issuer_url : null
}

output "cluster_username" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.username
  sensitive = true
}

output "cluster_password" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.password
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.host
  sensitive = true
}

output "fqdn" {
  value = var.enable_private_cluster ? null : azurerm_kubernetes_cluster.this.fqdn
}

output "ssh_private_key" {
  value     = try(tls_private_key.ssh[0].private_key_pem, null)
  sensitive = true
}

output "ssh_private_key_storage_blob_id" {
  value = try(azurerm_storage_blob.ssh-private-key[0].id, null)
}

output "ssh_private_key_storage_blob_url" {
  value = try(azurerm_storage_blob.ssh-private-key[0].url, null)
}

output "log_analytics_workspace_id" {
  value = try(azurerm_log_analytics_workspace.this[0].id, null)
}

output "kubeconfig_cmd" {
  value = "az account set --subscription ${data.azurerm_subscription.current.subscription_id}\naz aks get-credentials -g ${var.resource_group_name} -n ${var.cluster_name} --overwrite-existing"
}