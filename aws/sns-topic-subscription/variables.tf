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

variable "sns_topic_name" {
  description = "Name of the SNS topic to subscribe to."
  type        = string
}

# TODO: When TF v1.30 is released, use optional(bool, false) for 'raw_message_delivery' and remove coalesce().
variable "subscribing_endpoints" {
  description = "A map of configuration for endpoints that will subscribe to the SNS topic. The raw_message_delivery option is for sqs and https only."
  type        = map(object({
    protocol              = string
    raw_message_delivery  = optional(bool)
    filter_policy         = optional(string)
  }))
  validation {
    condition = alltrue(
      [for v in var.subscribing_endpoints : (contains(["sqs", "sms", "lambda", "email", "https"], v["protocol"]))]
    )
    error_message = "Required protocol can only be sqs, sms, lambda, email, or https."
  }
}