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

output "rest_api_arn" {
  value = aws_api_gateway_rest_api.this.arn
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "execution_arn_for_lambda" {
  value = aws_api_gateway_stage.this.execution_arn
}

output "cloudwatch_log_group_info" {
  value = tomap({
    name = aws_cloudwatch_log_group.this.name
    id   = aws_cloudwatch_log_group.this.id
    arn  = aws_cloudwatch_log_group.this.arn
  })
}

output "curl_custom_domain_url" {
  # May take a minute to become available on initial deploy.
  value = try("curl https://${local.api_custom_fqdn}${local.api_domain_subdirectory}/<resource-path>", null)
}

output "curl_stage_invoke_url" {
  value = "curl ${aws_api_gateway_stage.this.invoke_url}/<resource-path>"
}