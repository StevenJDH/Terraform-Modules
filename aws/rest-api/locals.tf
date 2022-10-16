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

locals {
  cloudwatch_role_arn      = var.cloudwatch_role_arn_for_api_gateway == null ? aws_iam_role.api-gateway-cloudwatch[0].arn : var.cloudwatch_role_arn_for_api_gateway
  enable_acm_custom_domain = var.enable_acm_custom_domain && (var.endpoint_type == "REGIONAL" || var.endpoint_type == "EDGE")
  api_custom_fqdn          = local.enable_acm_custom_domain ? "${var.api_subdomain_name}.${var.api_root_domain_name}" : null

  domain_validation_options = !local.enable_acm_custom_domain ? {} : tomap({
    for dvo in aws_acm_certificate.this[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  })
}