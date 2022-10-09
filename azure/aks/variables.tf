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

variable "location" {
  description = "Azure location."
  type        = string
}

variable "create_resource_group" {
  description = "Indicates whether or not to create a resource group."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Name of resource group."
  type        = string
}

variable "cluster_name" {
  description = "The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
  type        = string
  default     = "aks"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). Minor version aliases such as 1.22 are also supported."
  type        = string
  default     = null
}

variable "enable_private_cluster" {
  description = "Indicates whether or not to provide a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located."
  type        = bool
  default     = false
}

variable "cluster_sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)."
  type        = string
  default     = "Free"
  validation {
    condition     = contains(["Free", "Paid"], var.cluster_sku_tier)
    error_message = "The cluster sku tier can only be Free or Paid."
  }
}

variable "enable_oidc_issuer" {
  description = "Indicates whether or not to enable the OIDC issuer URL. This is needed for things like Workload Identities. OIDC issuer URL requires that the Preview Feature Microsoft.ContainerService/EnableOIDCIssuerPreview is enabled and the Provider is re-registered to get the change propagated."
  type        = bool
  default     = false
}

variable "default_node_pool" {
  description = "The default node pool configuration. Changes to vm_size forces a rebuild of AKS."
  type = object({
    name                = optional(string, "default")
    vm_size             = string
    vnet_subnet_id      = optional(string)
    node_count          = optional(number, 1)
    enable_auto_scaling = optional(bool, false)
    scaling_min_count   = optional(number, 1)
    scaling_max_count   = optional(number, 1)
  })

  default = {
    name = "default"
    vm_size = "Standard_D2_v2"
    vnet_subnet_id = null
    node_count = 1
    enable_auto_scaling = false
    scaling_min_count = 1
    scaling_max_count = 1
  }
}

variable "enable_ssh_access" {
  description = "Indicates whether or not to provide access for SSH communication to the linux nodes. If set to true, ensure that the Terraform state file is stored on encrypted storage like an Azure container with server-side encryption enabled to better protect the SSH private key in the state file."
  type        = bool
  default     = false
}

variable "ssh_private_key_rsa_bits" {
  description = "The size of the generated RSA key in bits."
  type        = number
  default     = 4096
}

variable "ssh_admin_username" {
  description = "The SSH admin username for the cluster. Changing this forces a new resource to be created."
  type        = string
  default     = "azureuser"
}

variable "save_ssh_private_key_locally" {
  description = "Indicates whether or not to save the generated SSH private key locally. If this file is removed, or a plan is done from a new machine for automation, Terraform will generate a diff to re-create it. This may cause unwanted noise in a plan. Alternatively, use `save_ssh_private_key_remotely` instead to mitigate this issue."
  type        = bool
  default     = true
}

variable "save_ssh_private_key_remotely" {
  description = "Indicates whether or not to save the generated SSH private key remotely to a pre-created Azure container. If set to true, `ssh_private_key_storage_account_name` and `ssh_private_key_container_name` are required."
  type        = bool
  default     = false
}

variable "ssh_private_key_storage_account_name" {
  description = "Name of the storage account to save the SSH private key file to. Requires `save_ssh_private_key_remotely` to be set to true."
  type        = string
  default     = null
}

variable "ssh_private_key_container_name" {
  description = "Name of the container to save the SSH private key file to. Requires `save_ssh_private_key_remotely` to be set to true. Containers are encrypted by default with Microsoft-managed keys (MMK)."
  type        = string
  default     = null
}

variable "ssh_key_container_folder_prefix" {
  description = "The folder prefix for the SSH private key file to nest within a folder like structure. For example, `backup/`, WITHOUT the leading slash, will save the SSH private key file as `backup/my-ssh.key`. Requires `save_ssh_private_key_remotely` to be set to true."
  type        = string
  default     = ""
}

variable "secondary_node_pools" {
  description = "Secondary node pool configuration. Changes to vm_size can be done without forcing a rebuild of AKS."
  type = list(object({
    name                = optional(string, "minion")
    node_count          = optional(number, 1)
    vm_size             = string
    vnet_subnet_id      = optional(string)
    os_type             = optional(string, "Linux")
    enable_auto_scaling = optional(bool, false)
    scaling_min_count   = optional(number, 1)
    scaling_max_count   = optional(number, 1)
    node_taints         = optional(list(string))
  }))

  default = [{
    name                = "minion"
    node_count          = 1
    vm_size             = "Standard_DS2_v2"
    vnet_subnet_id      = null
    os_type             = "Linux"
    enable_auto_scaling = false
    scaling_min_count   = 1
    scaling_max_count   = 1
    node_taints         = []
  },]
}

variable "enable_only_critical_addons" {
  description = "Indicates whether or not to taint default node pool with CriticalAddonsOnly=true:NoSchedule taint. Requires at least one secondary node pool. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "enable_http_application_routing" {
  description = "Indicates whether or not to enable HTTP Application Routing (managed NGiNX controller.) This is not meant for production use cases."
  type        = bool
  default     = false
}

variable "network_profile" {
  description = "Sets up a network profile with network plugin, policy, kubernetes service address, etc. for basic and advanced networking. Changing this forces a new resource to be created. For advanced networking, AKS clusters may not use 169.254.0.0/16, 172.30.0.0/16, 172.31.0.0/16, or 192.0.2.0/24 for the Kubernetes service address range, pod address range, or cluster virtual network address range. See [Choose a network model to use](https://docs.microsoft.com/en-us/azure/aks/configure-kubenet#choose-a-network-model-to-use) for more info."
  type        = object({
    network_plugin     = string
    network_policy     = optional(string)
    service_cidr       = optional(string, "10.100.0.0/16")
    dns_service_ip     = optional(string, "10.100.0.10")
    docker_bridge_cidr = optional(string, "172.17.0.1/16")
    outbound_type      = optional(string, "loadBalancer")
  })

  default = {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = "10.100.0.0/16"
    dns_service_ip     = "10.100.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    outbound_type      = "loadBalancer"
  }
}

variable "attach_container_registry_id" {
  description = "The Azure container registry id to attach to the Kubernetes Cluster with AcrPull role."
  type        = string
  default     = null
}

variable "create_log_analytics_workspace_and_container_insights" {
  description = "Indicates whether or not to create a log analytics workspace with container insights enabled."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_name" {
  description = "Name of the log analytics workspace, which has to be globally unique. Required if workspace is being created."
  type        = string
  default     = null
}

variable "log_analytics_workspace_sku" {
  description = "Log analytics workspace SKU."
  type        = string
  default     = "PerGB2018" # Reference: https://azure.microsoft.com/pricing/details/monitor.
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}