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

variable "topic_names" {
  description = "Name of topic."
  type        = list(string)
}

variable "fifo_topic" {
  description = "(Optional) Indicates whether or not to create a FIFO (first-in-first-out) topic. Default is false."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "(Optional) Enables content-based deduplication for FIFO topics."
  type        = bool
  default     = false
}


variable "min_delay_target_seconds" {
  description = "The minimum delay for a retry. 1 to maximum delay."
  type        = number
  default     = 20
}

variable "max_delay_target_seconds" {
  description = "The maximum delay for a retry. Minimum delay to 3,600."
  type        = number
  default     = 20
}

variable "num_retries" {
  description = "The total number of retries, including immediate, pre-backoff, backoff, and post-backoff retries. 0 to 100."
  type        = number
  default     = 3
}

variable "num_max_delay_retries" {
  description = "The number of retries in the post-backoff phase, with the maximum delay between them. 0 or greater."
  type        = number
  default     = 0
}

variable "num_no_delay_retries" {
  description = "The number of retries to be done immediately, with no delay between them. 0 or greater."
  type        = number
  default     = 0
}

variable "num_min_delay_retries" {
  description = "The number of retries in the pre-backoff phase, with the specified minimum delay between them. 0 or greater."
  type        = number
  default     = 0
}

variable "backoff_function" {
  description = "The model for backoff between retries. One of four options: arithmetic, exponential, geometric, or linear."
  type        = string
  default     = "linear"
}

variable "max_receives_per_second" {
  description = "The maximum number of deliveries per second, per subscription. 1 or greater. Default: No throttling (null)."
  type        = number
  default     = null
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}