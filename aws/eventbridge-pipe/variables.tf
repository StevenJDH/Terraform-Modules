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

variable "name" {
  description = "Name of the EventBridge Pipe. Changes force a new resource."
  type        = string
}

variable "description" {
  description = "Pipe description detailing its purpose."
  type        = string
  default     = null
}

variable "eventbridge_pipe_role_arn" {
  description = "ARN of the role that allows the pipe to retrieve and send data to the target."
  type        = string
}

variable "event_source_arn" {
  description = "ARN of the source resource. Changes force a new resource."
  type        = string
}

variable "event_source_parameters" {
  description = "Parameters required to set up the pipe source."
  type        = any
  default     = {}
}

variable "event_target_arn" {
  description = "ARN of the target resource."
  type        = string
}

variable "event_target_parameters" {
  description = "Parameters required to set up the pipe target."
  type        = any
  default     = {}
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}