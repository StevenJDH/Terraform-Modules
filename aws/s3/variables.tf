/*
 * This file is part of Terraform-Modules <https://github.com/StevenJDH/Terraform-Modules>.
 * Copyright (C) 2022-2023 Steven Jenkins De Haro.
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

variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "add_random_suffix" {
  description = "Indicates whether or not to add a random suffix to the bucket name to increase its chances of being unique."
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Indicates whether or not if S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Indicates whether or not if S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Indicates whether or not if S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Indicates whether or not if S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "additional_resource_policy_statements" {
  description = "Attach additional resource-based policy statements to the S3 bucket."
  type        = list(any)
  default     = []
}

variable "enable_versioning" {
  description = "Indicates whether or not to enable versioning on the bucket. Once enabled, disabling it will only suspend versioning on the bucket. AWS recommends waiting 15 minutes after initially enabling versioning before issuing write operations."
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "Sets the lifecycle rules that define actions that S3 applies to a group of objects such as transition and or expiration actions."
  type = list(object({
    rule_name               = string
    enable_rule             = bool
    filter_prefix           = optional(string, "") # TF needed default.
    filter_tags             = optional(map(string), null) # TF needed default.
    filter_size_lt_bytes    = optional(number, null) # TF needed default.
    filter_size_gt_bytes    = optional(number, null) # TF needed default.
    expiration_days         = optional(number, 0)
    transition              = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    version_expiration_days = optional(number, 0)
    version_transition      = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })), [])
    delete_incomplete_mp_upload_days = optional(number, 0)
  }))
  default = [
    {
      rule_name               = "Housekeeping"
      enable_rule             = true
      filter_prefix           = ""
      filter_tags             = null
      filter_size_lt_bytes    = null
      filter_size_gt_bytes    = null
      expiration_days         = 0
      transition              = []
      version_expiration_days = 30
      version_transition      = []
      delete_incomplete_mp_upload_days = 1
    },
  ]
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}