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

# TODO: When TF v1.30 is released, use optional(bool, false) for 'secure' and remove coalesce().
variable "configuration" {
  description = "A map of configuration. Valid tiers are Standard, Advanced, and Intelligent-Tiering, but if not specified, default for region is used."
  type        = map(object({
    description = optional(string)
    value       = string
    tier        = optional(string)
    secure      = optional(bool)
  }))
}

variable "secret" {
  description = "Indicates whether or not to define configuration as a secret."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}