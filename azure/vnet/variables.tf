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

variable "name" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "address_space" {
  description = "The address space that is used for the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_servers" {
  description = "List of IP addresses of DNS servers."
  type        = list(string)
  default     = []
}

# TODO: When TF v1.30 is released, use optional(list(string), [] or null) for 'service_endpoints' and remove coalesce().
variable "subnet_configuration" {
  description = "Sets the configuration for the subnet. For attributes nat_gateway_id, network_security_group_id and route_table_id, set to null if not needed. The new_bits attribute is the number of additional bits with which to extend the prefix. For example, if given a prefix ending in /16 and a new_bits value of 88, the resulting subnet address will have length /24."
  type = list(object({
    subnet_name               = string
    new_bits                  = number
    service_endpoints         = optional(list(string))
    nat_gateway_id            = string
    network_security_group_id = string
    route_table_id            = string
  }))
  default = [{
    subnet_name               = "snet-default"
    new_bits                  = 8
    service_endpoints         = null
    nat_gateway_id            = null
    network_security_group_id = null
    route_table_id            = null
  },]
}

variable "enforce_private_link_endpoint_network_policies" {
  description = "Enable or Disable network policies for the private link endpoint on the subnet. Setting this to true will Disable the policy and setting this to false will Enable the policy. Network policies, like network security groups (NSG), are not supported for Private Link Endpoints or Private Link Services. In order to deploy a Private Link Endpoint on a given subnet, you must set the enforce_private_link_endpoint_network_policies attribute to true. This setting is only applicable for the Private Link Endpoint, for all other resources in the subnet access is controlled based via the Network Security Group."
  type        = bool
  default     = false
}

variable "enforce_private_link_service_network_policies" {
  description = "Enable or Disable network policies for the private link service on the subnet. Setting this to true will Disable the policy and setting this to false will Enable the policy. In order to deploy a Private Link Service on a given subnet, you must set the enforce_private_link_service_network_policies attribute to true. This setting is only applicable for the Private Link Service, for all other resources in the subnet access is controlled based on the Network Security Group."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}