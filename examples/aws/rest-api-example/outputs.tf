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

output "public_rest_api_arn" {
  value = module.public-rest-api.rest_api_arn
}

output "public_rest_api_id" {
  value = module.public-rest-api.rest_api_id
}

output "public_execution_arn_for_lambda" {
  value = module.public-rest-api.execution_arn_for_lambda
}

output "public_cloudwatch_log_group_info" {
  value = module.public-rest-api.cloudwatch_log_group_info
}

output "public_curl_custom_domain_url" {
  # May take a minute to become available on initial deploy.
  value = module.public-rest-api.curl_custom_domain_url
}

output "public_curl_stage_invoke_url" {
  value = module.public-rest-api.curl_stage_invoke_url
}

output "private_rest_api_arn" {
  value = module.private-rest-api.rest_api_arn
}

output "private_rest_api_id" {
  value = module.private-rest-api.rest_api_id
}

output "private_execution_arn_for_lambda" {
  value = module.private-rest-api.execution_arn_for_lambda
}

output "private_cloudwatch_log_group_info" {
  value = module.private-rest-api.cloudwatch_log_group_info
}

output "private_curl_custom_domain_url" {
  # May take a minute to become available on initial deploy.
  value = module.private-rest-api.curl_custom_domain_url
}

output "private_curl_stage_invoke_url" {
  value = module.private-rest-api.curl_stage_invoke_url
}

output "custom_domain_rest_api_arn" {
  value = module.custom-domain-rest-api.rest_api_arn
}

output "custom_domain_rest_api_id" {
  value = module.custom-domain-rest-api.rest_api_id
}

output "custom_domain_execution_arn_for_lambda" {
  value = module.custom-domain-rest-api.execution_arn_for_lambda
}

output "custom_domain_cloudwatch_log_group_info" {
  value = module.custom-domain-rest-api.cloudwatch_log_group_info
}

output "custom_domain_curl_custom_domain_url" {
  # May take a minute to become available on initial deploy.
  value = module.custom-domain-rest-api.curl_custom_domain_url
}

output "custom_domain_curl_stage_invoke_url" {
  value = module.custom-domain-rest-api.curl_stage_invoke_url
}