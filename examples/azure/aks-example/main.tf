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

module "public_aks" {
  source = "../../../azure/aks"

  cluster_name                 = "aks-public-example-${local.stage}"
  kubernetes_version           = "1.23"
  create_resource_group        = true
  resource_group_name          = "rg-public-aks-example-${local.stage}"
  location                     = var.location
  dns_prefix                   = "public-aks"
  network_profile              = local.public_network_profile
  default_node_pool            = local.public_default_pool
  secondary_node_pools         = local.public_secondary_node_pools
  # Ensure that the OIDC Issuer feature flag is enabled first. See module README.md for more info.
  enable_oidc_issuer           = true
  enable_ssh_access            = true
  save_ssh_private_key_locally = true

  create_log_analytics_workspace_and_container-insights = true
  log_analytics_workspace_name = "log-public-aks-example-workspace-${local.stage}"

  tags = local.tags
}

module "private_aks" {
  source = "../../../azure/aks"

  cluster_name              = "aks-private-example-${local.stage}"
  kubernetes_version        = "1.23"
  enable_private_cluster    = true
  create_resource_group     = true
  resource_group_name       = "rg-private-aks-example-${local.stage}"
  location                  = var.location
  dns_prefix                = "private-aks"
  network_profile           = local.private_network_profile
  default_node_pool         = local.private_default_pool
  secondary_node_pools      = local.private_secondary_node_pools
  # Ensure that the OIDC Issuer feature flag is enabled first. See module README.md for more info.
  enable_oidc_issuer        = true

  create_log_analytics_workspace_and_container-insights = true
  log_analytics_workspace_name = "log-private-aks-example-workspace-${local.stage}"

  tags = local.tags
}