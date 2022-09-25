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

module "simple-lambda" {
  source = "../../../aws/lambda"

  s3_bucket_name   = local.s3_bucket_name
  region           = var.region
  lambda_functions = [
    {
      function_name            = "hello-world-example-${local.stage}"
      description              = "This is an example lambda."
      runtime                  = "java11"
      handler                  = "com.example.App::handleRequest"
      timeout_in_seconds       = 30
      cw_log_retention_in_days = 7
      deployment_package_key   = "${local.stage}/hello-world-example-0.1.0-aws.zip"
    },
  ]

  tags = local.tags
}

module "vpc-lambda" {
  source = "../../../aws/lambda"

  s3_bucket_name   = local.s3_bucket_name
  region           = var.region
  lambda_functions = [
    {
      function_name            = "hello-world-example2-${local.stage}"
      description              = "This is an example lambda."
      runtime                  = "java11"
      handler                  = "com.example.App::handleRequest"
      timeout_in_seconds       = 30
      cw_log_retention_in_days = 7
      deployment_package_key   = "${local.stage}/hello-world-example-0.1.0-aws.zip"
      vpc_subnet_ids           = var.subnet_ids
      vpc_security_group_ids   = var.security_group_ids
    },
  ]

  tags = local.tags
}

module "efs-lambda" {
  source = "../../../aws/lambda"

  s3_bucket_name   = local.s3_bucket_name
  region           = var.region
  lambda_functions = [
    {
      function_name            = "hello-world-example3-${local.stage}"
      description              = "This is an example lambda."
      runtime                  = "java11"
      handler                  = "com.example.App::handleRequest"
      timeout_in_seconds       = 30
      cw_log_retention_in_days = 7
      deployment_package_key   = "${local.stage}/hello-world-example-0.1.0-aws.zip"
      enable_efs_support       = true
      efs_access_point_arn     = data.aws_efs_access_point.selected.arn
      efs_local_mount_path     = "test" # Do not include '/mnt/' prefix.
      efs_file_system_id       = data.aws_efs_access_point.selected.file_system_id
      efs_enable_read_write    = true
      vpc_subnet_ids           = var.subnet_ids
      vpc_security_group_ids   = var.security_group_ids
    },
  ]

  tags = local.tags
}