/*
 * This file is part of Terraform-Modules <https://github.com/StevenJDH/Terraform-Modules>.
 * Copyright (C) 2024 Steven Jenkins De Haro.
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

variable "service_principal_name" {
  description = "Name of service principal."
  type        = string
}

variable "client_secret_rotation_days" {
  description = "Number of days to wait until client secret is regenerated, max 730 days. Changing this forces the creation of a new secret."
  type        = number
  default     = 730
  validation {
    condition = var.client_secret_rotation_days >= 1 && var.client_secret_rotation_days <= 730
    error_message = "Client secret rotation days must be a value between 1-730 inclusively."
  }
}

variable "owners" {
  description = "A set of object IDs of principals that will be granted ownership of the application/service principal."
  type        = set(string)
}

variable "role_definition_name" {
  description = "The name of the custom role definition or built-in role if `create_custom_role_definition` is set to `false`."
  type        = string
}

variable "scope" {
  description = "The scope at which the role will be applied."
  type        = string
}

variable "create_custom_role_definition" {
  description = "Indicates whether or not to create a custom role definition."
  type        = bool
  default     = false
}

variable "custom_role_description" {
  description = "A description of the custom role definition."
  type        = string
  default     = null
}

variable "custom_role_actions" {
  description = "One or more allowed actions such as `*` for the custom role definition."
  type        = list(string)
  default     = []
}

variable "custom_role_not_actions" {
  description = "One or more disallowed actions such as `*` for the custom role definition."
  type        = list(string)
  default     = []
}

variable "custom_role_data_actions" {
  description = "One or more allowed data actions such as `*` for the custom role definition."
  type        = set(string)
  default     = []
}

variable "custom_role_not_data_actions" {
  description = "One or more disallowed data actions such as `*` for the custom role definition."
  type        = set(string)
  default     = []
}

variable "custom_role_assignable_scopes" {
  description = "One or more assignable scopes for the custom role definition."
  type        = list(string)
  default     = []
}