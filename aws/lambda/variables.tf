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

variable "s3_bucket_name" {
  description = "S3 bucket location containing the function deployment packages. This bucket must reside in the same AWS region where the Lambda functions are being created."
  type        = string
}

variable "lambda_functions" {
  description = "Sets the Lambda configuration, which manages, basic config, VPC access, EFS mount points, and role config. The function deployment packages must be available in a centralized S3 bucket along with their hash file to detect changes. If `deployment_package_key` isn't specified, then it's assumed that the deployment package key matches the function name with `.zip` at the end. The deployment package key can also include folder names in the S3 bucket. See [Runtimes](https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime) for valid values when selecting the programming language."
  type        = list(object({
    function_name            = string
    description              = optional(string)
    runtime                  = string
    handler                  = string
    timeout_in_seconds       = optional(number, 3)
    ephemeral_storage_size   = optional(number, 512)
    environment_variables    = optional(map(string), {})
    deployment_package_key   = optional(string)
    s3_zip_object_version    = optional(string)
    s3_hash_object_version   = optional(string)
    memory_size_in_mb        = optional(number, 128)
    reserved_concurrency     = optional(number, -1)
    cw_log_retention_in_days = optional(number, 90)
    enable_efs_support       = optional(bool, false)
    efs_access_point_arn     = optional(string, null)
    efs_local_mount_path     = optional(string, null)
    efs_file_system_id       = optional(string, null)
    efs_enable_read_write    = optional(bool, false)
    vpc_subnet_ids           = optional(list(string), [])
    vpc_security_group_ids   = optional(list(string), [])
    invoke_with_payload      = optional(string)
    additional_policy_arns   = optional(list(string), [])
  }))
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}