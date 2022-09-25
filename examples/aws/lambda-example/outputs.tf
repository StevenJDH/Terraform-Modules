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

output "simple_lambda_function_details" {
  value = module.simple-lambda.function_details
}

output "simple_lambda_cloudwatch_log_group_info" {
  value = module.simple-lambda.cloudwatch_log_group_info
}

output "simple_lambda_invoked_lambda_response" {
  value = module.simple-lambda.invoked_lambda_response
}

output "vpc_lambda_function_details" {
  value = module.vpc-lambda.function_details
}

output "vpc_lambda_cloudwatch_log_group_info" {
  value = module.vpc-lambda.cloudwatch_log_group_info
}

output "vpc_lambda_invoked_lambda_response" {
  value = module.vpc-lambda.invoked_lambda_response
}

output "efs_lambda_function_details" {
  value = module.efs-lambda.function_details
}

output "efs_lambda_cloudwatch_log_group_info" {
  value = module.efs-lambda.cloudwatch_log_group_info
}

output "efs_lambda_invoked_lambda_response" {
  value = module.efs-lambda.invoked_lambda_response
}