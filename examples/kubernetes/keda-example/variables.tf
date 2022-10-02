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

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "eu-west-3"
}

variable "eks_cluster_name" {
  description = "Name of the AWS EKS cluster."
  type        = string
  default     = null
}

variable "aks_cluster_name" {
  description = "Name of the Azure AKS cluster."
  type        = string
  default     = null
}

variable "aks_cluster_resource_group_name" {
  description = "Name of the Resource Group in which the AKS cluster exists."
  type        = string
  default     = null
}