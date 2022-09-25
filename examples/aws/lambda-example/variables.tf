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

variable "region" {
  description = "AWS region."
  type        = string
  default     = "eu-west-3"
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the Lambda function."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the Lambda function."
  type        = list(string)
}

variable "efs_access_point_id" {
  description = "ID that identifies the EFS access point."
  type        = string
}