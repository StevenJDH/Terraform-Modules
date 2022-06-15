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

variable "private_dns_record" {
  description = "Indicates whether or not this is for a private DNS A record."
  type        = bool
  default     = true
}

variable "create_dns_zone" {
  description = "Indicates whether or not to create a DNS zone."
  type        = bool
  default     = false
}

variable "dns_zone_name" {
  description = "Name of DNS zone."
  type        = string
}

variable "dns_a_record_name" {
  description = "Name of DNS A record."
  type        = string
}

variable "ttl" {
  description = "TTL for private DNS A record."
  type        = number
  default     = 3600
}

variable "ip_address_for_a_record" {
  description = "IP address for private DNS A record."
  type        = string
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