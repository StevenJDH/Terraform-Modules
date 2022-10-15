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

module "public-rest-api" {
  source = "../../../aws/rest-api"

  api_name          = "public-api-example-${local.stage}"
  endpoint_type     = "REGIONAL"
  stage_name        = local.stage
  stage_variables   = local.stage_variables
  api_specification = local.api_spec

  cloudwatch_logging_level            = "ERROR"
  enable_cloudwatch_metrics           = true
  enable_request_and_response_logging = true
  cloudwatch_log_retention_in_days    = 7

  tags = local.tags
}

module "private-rest-api" {
  source = "../../../aws/rest-api"

  api_name          = "private-api-example-${local.stage}"
  endpoint_type     = "PRIVATE"
  stage_name        = local.stage
  stage_variables   = local.stage_variables
  vpc_endpoint_ids  = [data.aws_vpc_endpoint.selected.id]
  api_specification = local.api_spec

  cloudwatch_logging_level            = "ERROR"
  enable_cloudwatch_metrics           = true
  enable_request_and_response_logging = true
  cloudwatch_log_retention_in_days    = 7

  tags = local.tags
}

module "custom-domain-rest-api" {
  source = "../../../aws/rest-api"

  api_name                 = "custom-domain-api-example-${local.stage}"
  endpoint_type            = "REGIONAL"
  stage_name               = local.stage
  stage_variables          = local.stage_variables
  enable_acm_custom_domain = true
  api_root_domain_name     = "domain.com"
  api_subdomain_name       = "api-${local.stage}"
  api_specification        = local.api_spec

  cloudwatch_logging_level            = "ERROR"
  enable_cloudwatch_metrics           = true
  enable_request_and_response_logging = true
  cloudwatch_log_retention_in_days    = 7

  tags = local.tags
}