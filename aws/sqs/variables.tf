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

variable "queue_names" {
  description = "List of queue names."
  type        = list(string)
}

variable "fifo_queue" {
  description = "(Optional) Indicates whether or not to create a FIFO (first-in-first-out) queue. Default is false."
  type        = bool
  default     = false
}

variable "create_dlq" {
  description = "(Optional) Indicates whether or not to create a DLQ. Default is false."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "(Optional) Enables content-based deduplication for FIFO queues."
  type        = bool
  default     = false
}

variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level. Valid values are 'messageGroup' and 'queue' (default)."
  type        = string
  default     = "queue"
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days)."
  type        = number
  default     = 345600
}

variable "message_retention_dlq_seconds" {
  description = "The number of seconds Amazon SQS retains a DLQ message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days)."
  type        = number
  default     = 345600
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). The default for this attribute is 30."
  type        = number
  default     = 30
}

variable "visibility_timeout_dlq_seconds" {
  description = "The visibility timeout for the DLQ queue. An integer from 0 to 43200 (12 hours). The default for this attribute is 30."
  type        = number
  default     = 30
}

variable "max_receive_count" {
  description = "The total number of retries. The default is 3."
  type        = number
  default     = 3
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). The default for this attribute is 0 seconds."
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). The default for this attribute is 0, meaning that the call will return immediately."
  type        = number
  default     = 0
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}