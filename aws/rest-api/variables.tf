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

variable "api_name" {
  description = "Name of the API Gateway REST API. This corresponds to the `info.title` field, and if the argument value is different than the OpenAPI value, the argument value will override the OpenAPI value."
  type        = string
}

variable "api_specification" {
  description = "OpenAPI specification that defines the set of routes and integrations to create as part of the REST API. Use `API` > `Stages` > `Export` > `OpenAPI 3 + API Gateway Extensions` JSON format, and remove the `servers` and `x-amazon-apigateway-policy` blocks if present."
  type        = string
}

variable "endpoint_type" {
  description = "Type of endpoint to use for the API. Valid values are EDGE, REGIONAL and PRIVATE."
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["EDGE", "REGIONAL", "PRIVATE"], var.endpoint_type)
    error_message = "Required endpoint type can only be EDGE, REGIONAL and PRIVATE."
  }
}

variable "vpc_endpoint_ids" {
  description = "Set of VPC Endpoint identifiers. Only supported for PRIVATE endpoint type. Requires the [VPC Endpoint](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/vpc-endpoint) module, or any other means to create the same."
  type        = set(string)
  default     = []
}

variable "stage_name" {
  description = "Name of the stage."
  type        = string
}

variable "stage_variables" {
  description = "A map that defines the stage variables to avoid hard-coding information. For more information, see [Setting up stage variables for a REST API deployment](https://docs.aws.amazon.com/apigateway/latest/developerguide/stage-variables.html)."
  type        = map(string)
  default     = null
}

variable "cloudwatch_role_arn_for_api_gateway" {
  description = "ARN of an existing IAM role for CloudWatch to allow logging & monitoring in API Gateway. This is an account level setting, so either specify an existing ARN, or a new role will be created and used."
  type        = string
  default     = null
}

variable "cloudwatch_logging_level" {
  description = "Logging level for method, which effects the log entries pushed to Amazon CloudWatch Logs. The available levels are OFF, ERROR, and INFO. Prefer ERROR over INFO as a recommendation to save cost."
  type        = string
  default     = "OFF"
  validation {
    condition     = contains(["OFF", "ERROR", "INFO"], var.cloudwatch_logging_level)
    error_message = "CloudWatch logging level can only be OFF, ERROR, and INFO."
  }
}

variable "enable_request_and_response_logging" {
  description = "Indicates whether or not to log full request/response data."
  type        = bool
  default     = false
}

variable "enable_cloudwatch_metrics" {
  description = "Indicates whether or not to enable CloudWatch Metrics."
  type        = bool
  default     = false
}

variable "cloudwatch_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 90
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.cloudwatch_log_retention_in_days)
    error_message = "Required CloudWatch log retention in days can only be 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  }
}

variable "throttling_burst_limit" {
  description = "Throttling burst limit. Setting this to -1 disables throttling."
  type        = number
  default     = -1
}

variable "throttling_rate_limit" {
  description = "Throttling rate limit. Setting this to -1 disables throttling."
  type        = number
  default     = -1
}

variable "enable_acm_custom_domain" {
  description = "Indicates whether or not to enable the use of a custom domain name for an API using a free certificate from AWS Certificate Manager (ACM). Requires a domain name to have been previously registered in AWS Route 53."
  type        = bool
  default     = false
}

variable "hosted_zone_id" {
  description = "The identifier of the hosted zone to use for storing DNS records. Private hosted zones are not supported."
  type        = string
  default     = null
}

variable "api_root_domain_name" {
  description = "The root (apex) domain name for the API, for example, `domain.com`. See `api_subdomain_name` to set a custom subdomain."
  type        = string
  default     = null
}

variable "api_domain_subdirectory" {
  description = "The subdirectory that comes after the `api_root_domain_name`, for example, `myservice`. Slashes are not supported."
  type        = string
  default     = null
}

variable "api_subdomain_name" {
  description = "The subdomain name for the API, for example, `api`. See `api_root_domain_name` to set a custom root domain."
  type        = string
  default     = "api"
}

variable "lambda_function_name" {
  description = "Name of a Lambda function where an additional resource-based policy statement will be added with access permissions for API Gateway. The permissions will allow invocations from any method and resource path for a specific stage within the API Gateway REST API. If more restrictive permissions are needed, then use instead the `execution_arn_for_lambda` output along with a `aws_lambda_permission` resource."
  type        = string
  default     = null
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}