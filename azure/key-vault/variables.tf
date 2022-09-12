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

variable "key_vault_name" {
  description = "Name of Key Vault."
  type        = string
  validation {
    condition     = length(var.key_vault_name) >= 3 && length(var.key_vault_name) <= 24
    error_message = "Key Vault name may only contain alphanumeric characters and dashes and must be between 3-24 chars."
  }
}

variable "enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
  default     = 90
}

variable "enable_purge_protection" {
  description = "Indicates whether or not to enable purge protection. Once Purge Protection has been Enabled it's not possible to Disable it. If Key Vault is deleted, Azure will purge the instance in 90 days."
  type        = bool
  default     = false
}

variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
  default     = "standard"
  validation {
    condition = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be standard or premium."
  }
}

variable "enable_rbac_authorization" {
  description = "Indicates whether or not Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. For more information, see [Azure built-in roles for Key Vault data plane operations](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations)."
  type        = bool
  default     = false
}

variable "network_acls" {
  description = "Specifies whether Azure service traffic can bypass the network rules, default action to use when no rules match from ip_rules / virtual_network_subnet_ids, and One or more Subnet IDs which should be able to access this Key Vault."
  type = object({
    bypass_network_acls           = bool,
    allow_when_no_acl_rules_match = bool,
    ip_rules                      = list(string),
    virtual_network_subnet_ids    = list(string)
  })
  default     = null
}

variable "access_policies" {
  description = "A map of up to 16 objects describing access policies."
  type        = map(object({
    certificate_permissions = list(string)
    key_permissions         = list(string)
    secret_permissions      = list(string)
    storage_permissions     = list(string)
  }))
  default     = null
}

variable "create_private_endpoint" {
  description = "Indicates whether or not to create a private endpoint."
  type        = bool
  default     = false
}

variable "subnet_endpoint_id" {
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "create_private_dns_record" {
  description = "Indicates whether or not to create a private dns record for the private endpoint."
  type        = bool
  default     = false
}

variable "create_private_dns_zone" {
  description = "Indicates whether or not to create a DNS zone."
  type        = bool
  default     = false
}

variable "create_private_dns_resource_group" {
  description = "Indicates whether or not to create a private dns resource group."
  type        = bool
  default     = true
}

variable "private_dns_resource_group_name" {
  description = "Name of DNS resource group."
  type        = string
  default     = null
}

variable "ttl" {
  description = "TTL for private DNS A record."
  type        = number
  default     = 3600
}

variable "create_private_dns_zone_vnet_link" {
  description = "Indicates whether or not to create a private DNS zone virtual network link."
  type        = bool
  default     = false
}

variable "virtual_network_id" {
  description = "Virtual network Id for private DNS zone virtual network link."
  type        = string
  default     = null
}

variable "enable_auto_registration" {
  description = "Indicates whether or not to enable auto-registration of virtual machine records in the virtual network in the Private DNS zone."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}