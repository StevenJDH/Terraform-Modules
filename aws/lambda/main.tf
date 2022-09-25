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

resource "aws_lambda_function" "this" {
  count = length(var.lambda_functions)

  function_name                  = var.lambda_functions[count.index].function_name
  description                    = var.lambda_functions[count.index].description
  runtime                        = var.lambda_functions[count.index].runtime
  handler                        = var.lambda_functions[count.index].handler
  timeout                        = var.lambda_functions[count.index].timeout_in_seconds
  role                           = aws_iam_role.this[count.index].arn
  s3_bucket                      = var.s3_bucket_name
  s3_key                         = var.lambda_functions[count.index].deployment_package_key == null ? "${var.lambda_functions[count.index].function_name}.zip" : var.lambda_functions[count.index].deployment_package_key
  s3_object_version              = var.lambda_functions[count.index].s3_zip_object_version
  source_code_hash               = data.aws_s3_object.lambda-package-hash[count.index].body
  memory_size                    = var.lambda_functions[count.index].memory_size_in_mb
  reserved_concurrent_executions = var.lambda_functions[count.index].reserved_concurrency

  ephemeral_storage {
    size = var.lambda_functions[count.index].ephemeral_storage_size # Min 512 MB and Max 10240 MB.
  }

  dynamic "environment" {
    for_each = length(var.lambda_functions[count.index].environment_variables) > 0 ? [true] : []

    content {
      variables = var.lambda_functions[count.index].environment_variables
    }
  }

  dynamic "file_system_config" {
    for_each = var.lambda_functions[count.index].enable_efs_support ? [true] : []

    content {
      arn              = var.lambda_functions[count.index].efs_access_point_arn
      local_mount_path = "/mnt/${var.lambda_functions[count.index].efs_local_mount_path}"
    }
  }

  # If both subnet_ids and security_group_ids are empty, then vpc_config is considered to be empty or unset.
  vpc_config {
    subnet_ids         = var.lambda_functions[count.index].vpc_subnet_ids
    security_group_ids = var.lambda_functions[count.index].vpc_security_group_ids
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.cloud-watch-log-group,
    aws_cloudwatch_log_group.this,
  ]
}

resource "random_id" "this" {
  count = length(var.lambda_functions)

  byte_length = 4
}

resource "aws_iam_role" "this" {
  count = length(var.lambda_functions)

  name        = "${var.lambda_functions[count.index].function_name}-role-${random_id.this[count.index].hex}"
  description = "Amazon Lambda - Execution role."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "LambdaGrantAssumeRoleRights"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  count = length(var.lambda_functions)

  name              = "/aws/lambda/${var.lambda_functions[count.index].function_name}"
  retention_in_days = var.lambda_functions[count.index].cw_log_retention_in_days

  tags = var.tags
}

resource "aws_iam_policy" "cloud-watch-log-group" {
  count = length(var.lambda_functions)

  name        = "AWSLambdaBasicExecutionRole-CWL"
  path        = "/"
  description = "Provides write permissions to CloudWatch Logs."

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      # Not needed since log group is managed above by terraform.
      /*{
        "Effect"   = "Allow",
        "Action"   = "logs:CreateLogGroup",
        "Resource" = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      },*/
      {
        "Effect" = "Allow",
        "Action" = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_functions[count.index].function_name}:*"
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cloud-watch-log-group" {
  count = length(var.lambda_functions)

  role       = aws_iam_role.this[count.index].name
  policy_arn = aws_iam_policy.cloud-watch-log-group[count.index].arn
}

resource "aws_iam_role_policy_attachment" "additional" {
  count = length(local.policy_arns)

  role       = aws_iam_role.this[local.policy_arns[count.index].key].name
  policy_arn = local.policy_arns[count.index].policy_arn
}

resource "aws_iam_role_policy_attachment" "lambda-vpc-access-execution-role" {
  for_each = local.vpc_lambdas

  role       = aws_iam_role.this[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "efs-client-read-only-access" {
  for_each = tomap({
    for k, v in local.vpc_lambdas : k => v if v.enable_efs_support && !v.efs_enable_read_write
  })

  role       = aws_iam_role.this[each.key].name
  # Provides read only client access to an Amazon EFS file system.
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "efs-client-read-write-access" {
  for_each = tomap({
    for k, v in local.vpc_lambdas : k => v if v.enable_efs_support && v.efs_enable_read_write
  })

  role       = aws_iam_role.this[each.key].name
  # Provides read and write client access to an Amazon EFS file system.
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}

resource "aws_lambda_invocation" "this" {
  for_each = local.invoking_lambdas

  function_name = each.value.function_name
  input         = each.value.invoke_with_payload

  triggers = {
    redeployment = aws_lambda_function.this[each.key].source_code_hash
  }
}

resource "aws_lambda_event_source_mapping" "this" {
  for_each = local.lambdas_with_triggers

  event_source_arn = each.value.event_source_arn
  enabled          = true
  function_name    = aws_lambda_function.this[each.key].arn
  batch_size       = each.value.event_source_batch_size
}