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
  default     = "West Europe"
}

variable "subnet_name" {
  description = "Specifies the name of the Subnet. Only used by private AKS for advanced networking."
  type        = string
}

variable "subnet_vnet_name" {
  description = "Specifies the name of the Virtual Network this Subnet is located within. Only used by private AKS for advanced networking."
  type        = string
}

variable "subnet_resource_group_name" {
  description = "Specifies the name of the resource group the Virtual Network is located in. Only used by private AKS for advanced networking."
  type        = string
}