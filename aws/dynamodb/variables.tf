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

variable "table_name" {
  description = "Name of the table. Has to be unique within a region of the table."
  type        = string
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "Required billing mode can only be PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "table_class" {
  description = "Storage class of the table."
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
    error_message = "Required table class can only be STANDARD or STANDARD_INFREQUENT_ACCESS."
  }
}

variable "read_capacity" {
  description = "Number of read units for this table. Required if the billing_mode is set to PROVISIONED."
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Number of write units for this table. Required if the billing_mode is set to PROVISIONED."
  type        = number
  default     = 5
}

variable "partition_key" {
  description = "Attribute to use as the hash (partition) key. Must also be defined as an attribute. Changes force a new resource."
  type        = string
}

variable "sort_key" {
  description = "Attribute to use as the range (sort) key. Must also be defined as an attribute. Changes force a new resource."
  type        = string
  default     = null
}

variable "enable_stream" {
  description = "Indicates whether or not to enable DynamoDB Streams."
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream."
  type        = string
  default     = "NEW_IMAGE"
  validation {
    condition     = contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type)
    error_message = "Required stream view type can only be KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, or NEW_AND_OLD_IMAGES."
  }
}

variable "attributes" {
  description = "Set of nested attribute definitions. Only required for hash_key."
  type        = list(object({
    name = string
    type = string
  }))
  default     = [
    {
      name = "pk"
      type = "S"
    },
  ]
  validation {
    condition = alltrue(
      [for v in var.attributes : (contains(["S", "N", "B"], v["type"]))]
    )
    error_message = "Required attribute types can only be S, N, or B."
  }
}

variable "ttl_attribute_name" {
  description = "Name of the table attribute to store the TTL timestamp in. Setting this auto enables this feature."
  type        = string
  default     = null
}

variable "local_secondary_indexes" {
  description = "Describes up to 5 LSIs on the table. The `projection_type` supports one of `ALL`, `INCLUDE` or `KEYS_ONLY` where ALL projects every attribute into the index, KEYS_ONLY projects into the index only the table and index hash_key and sort_key attributes, INCLUDE projects into the index all of the attributes that are defined in non_key_attributes in addition to the attributes that KEYS_ONLY project. Forces new resource."
  type        = list(object({
    name               = string
    sort_key           = string
    projection_type    = string
    non_key_attributes = optional(list(string), null)
  }))
  default     = []
  validation {
    condition = length(var.local_secondary_indexes) <= 5
    error_message = "DynamoDB only supports up to 5 Local Secondary Indexes per table."
  }
}

variable "global_secondary_indexes" {
  description = "Describes up to 20 GSIs on the table. Read and write capacities are only required when billing_mode is set to `PROVISIONED`. The `projection_type` supports one of `ALL`, `INCLUDE` or `KEYS_ONLY` where ALL projects every attribute into the index, KEYS_ONLY projects into the index only the table and index hash_key and sort_key attributes, INCLUDE projects into the index all of the attributes that are defined in non_key_attributes in addition to the attributes that KEYS_ONLY project."
  type        = list(object({
    name               = string
    partition_key      = string
    sort_key           = optional(string)
    projection_type    = string
    non_key_attributes = optional(list(string), null)
    read_capacity      = optional(number, null)
    write_capacity     = optional(number, null)
  }))
  default     = []
  validation {
    condition = length(var.global_secondary_indexes) <= 20
    error_message = "DynamoDB only supports up to 20 Global Secondary Indexes per table."
  }
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}