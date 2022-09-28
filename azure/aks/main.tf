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

resource "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 1 : 0

  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_kubernetes_cluster" "this" {
  name                              = var.cluster_name
  location                          = var.create_resource_group ? azurerm_resource_group.this[0].location : var.location
  resource_group_name               = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  dns_prefix                        = var.dns_prefix # The dns_prefix_private_cluster is for when providing private DNS zone to private_dns_zone_id.
  kubernetes_version                = var.kubernetes_version
  private_cluster_enabled           = var.enable_private_cluster
  sku_tier                          = var.cluster_sku_tier
  role_based_access_control_enabled = true
  oidc_issuer_enabled               = var.enable_oidc_issuer
  http_application_routing_enabled  = var.enable_http_application_routing

  default_node_pool {
    name                         = var.default_node_pool.name
    node_count                   = var.default_node_pool.node_count
    vm_size                      = var.default_node_pool.vm_size
    vnet_subnet_id               = var.default_node_pool.vnet_subnet_id
    enable_auto_scaling          = var.default_node_pool.enable_auto_scaling # If false, set min_count and max_count to null.
    min_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.scaling_min_count : null
    max_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.scaling_max_count : null
    only_critical_addons_enabled = length(var.secondary_node_pools) > 0 && var.enable_only_critical_addons
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "linux_profile" {
    for_each = var.enable_ssh_access ? [true] : []

    content {
      admin_username = var.ssh_admin_username
      ssh_key {
        key_data = tls_private_key.ssh[0].public_key_openssh
      }
    }
  }

  dynamic "oms_agent" {
    for_each = var.create_log_analytics_workspace_and_container-insights ? [true] : []

    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.this[0].id
    }
  }

  dynamic "network_profile" {
    for_each = var.network_profile != null ? [true] : []

    content {
      network_plugin     = lower(var.network_profile.network_policy) == "azure" ? "azure" : var.network_profile.network_plugin
      network_policy     = var.network_profile.network_policy
      service_cidr       = var.network_profile.network_plugin == "kubenet" ? null : var.network_profile.service_cidr
      dns_service_ip     = var.network_profile.network_plugin == "kubenet" ? null : var.network_profile.dns_service_ip
      docker_bridge_cidr = var.network_profile.network_plugin == "kubenet" ? null : var.network_profile.docker_bridge_cidr
      outbound_type      = var.network_profile.outbound_type
      load_balancer_sku  = "standard"
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
      kubernetes_version,
    ]
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  count = length(var.secondary_node_pools)

  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  name                  = var.secondary_node_pools[count.index].name
  node_count            = var.secondary_node_pools[count.index].node_count
  vm_size               = var.secondary_node_pools[count.index].vm_size
  vnet_subnet_id        = var.secondary_node_pools[count.index].vnet_subnet_id
  os_type               = var.secondary_node_pools[count.index].os_type
  enable_auto_scaling   = var.secondary_node_pools[count.index].enable_auto_scaling # If false, set min_count and max_count to null.
  min_count             = var.secondary_node_pools[count.index].enable_auto_scaling ? var.secondary_node_pools[count.index].min_count : null
  max_count             = var.secondary_node_pools[count.index].enable_auto_scaling ? var.secondary_node_pools[count.index].max_count : null
  node_taints           = var.secondary_node_pools[count.index].node_taints

  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }

  tags = var.tags
}

resource "tls_private_key" "ssh" {
  count = var.enable_ssh_access ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = var.ssh_private_key_rsa_bits
}

resource "local_sensitive_file" "ssh-private-key" {
  count = var.enable_ssh_access && var.save_ssh_private_key_locally ? 1 : 0

  content         =  tls_private_key.ssh[0].private_key_pem
  filename        =  "${path.cwd}/${var.cluster_name}.pem"
  file_permission = "0700"
}

resource "azurerm_storage_blob" "ssh-private-key" {
  count = var.enable_ssh_access && var.save_ssh_private_key_remotely ? 1 : 0

  name                   = "${var.ssh_key_container_folder_prefix}${var.cluster_name}.pem"
  storage_account_name   = var.ssh_private_key_storage_account_name
  storage_container_name = var.ssh_private_key_container_name
  type                   = "Block"
  source_content         = tls_private_key.ssh[0].private_key_pem
  content_type           = "application/x-pem-file"
  content_md5            = md5(tls_private_key.ssh[0].private_key_pem)
}

resource "azurerm_log_analytics_workspace" "this" {
  count = var.create_log_analytics_workspace_and_container-insights ? 1 : 0

  name                = var.log_analytics_workspace_name
  location            = var.create_resource_group ? azurerm_resource_group.this[0].location : var.location
  resource_group_name = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  sku                 = var.log_analytics_workspace_sku

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "container-insights" {
  count = var.create_log_analytics_workspace_and_container-insights ? 1 : 0

  solution_name         = "ContainerInsights" # Must be same name as 'product' in plan below.
  location              = var.create_resource_group ? azurerm_resource_group.this[0].location : var.location
  resource_group_name   = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.this[0].id
  workspace_name        = azurerm_log_analytics_workspace.this[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "private-aks-network-contributor" {
  count = var.enable_private_cluster ? 1 : 0

  role_definition_name = "Network Contributor"
  scope                = var.default_node_pool.vnet_subnet_id
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks-acr-pull" {
  count = var.attach_container_registry_id != null ? 1 : 0

  role_definition_name             = "AcrPull"
  scope                            = var.attach_container_registry_id
  principal_id                     = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}