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

  public_network_profile = {
    network_plugin = "kubenet"
    network_policy = "calico"
  }

  public_default_pool = {
    name    = "defaultgru"
    vm_size = "Standard_D2_v2"
  }

  public_secondary_node_pools = [
    {
      name    = "minion"
      vm_size = "Standard_DS2_v2"
    },
  ]

  private_network_profile = {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = "10.100.0.0/16"
    dns_service_ip     = "10.100.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  private_default_pool = {
    name                = "defaultgru"
    vm_size             = "Standard_D2_v2"
    vnet_subnet_id      = data.azurerm_subnet.selected.id
    node_count          = 1
    enable_auto_scaling = false
    scaling_min_count   = 1
    scaling_max_count   = 1
  }

  private_secondary_node_pools = [
    {
      name                = "minion"
      node_count          = 1
      vm_size             = "Standard_DS2_v2"
      vnet_subnet_id      = data.azurerm_subnet.selected.id
      os_type             = "Linux"
      enable_auto_scaling = false
      scaling_min_count   = 1
      scaling_max_count   = 1
      node_taints         = []
    },
  ]

  tags = {
    environment = local.stage
    terraform   = true
  }
}