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

resource "aws_api_gateway_rest_api" "this" {
  name              = var.api_name
  body              = var.api_specification
  put_rest_api_mode = var.endpoint_type == "PRIVATE" ? "merge" : "overwrite"

  endpoint_configuration {
    types            = [var.endpoint_type]
    vpc_endpoint_ids = var.endpoint_type == "PRIVATE" ? var.vpc_endpoint_ids : null
  }

  tags = var.tags
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# As there is no API method for deleting account settings or resetting it to
# defaults, destroying this resource will keep your account settings intact.
# Will also create a "/aws/apigateway/welcome" log group that can be deleted.
resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.api-gateway-cloudwatch.arn
}

resource "aws_api_gateway_stage" "this" {
  deployment_id         = aws_api_gateway_deployment.this.id
  rest_api_id           = aws_api_gateway_rest_api.this.id
  stage_name            = var.stage_name
  cache_cluster_enabled = false
  xray_tracing_enabled  = false
  variables             = var.stage_variables

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.api-gateway-push-to-cloudwatch-logs,
    aws_api_gateway_account.this,
  ]
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    logging_level          = var.cloudwatch_logging_level
    metrics_enabled        = var.enable_cloudwatch_metrics
    data_trace_enabled     = var.enable_request_and_response_logging
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.this.id}/${var.stage_name}"
  retention_in_days = var.cloudwatch_log_retention_in_days

  tags = var.tags
}

resource "aws_iam_role" "api-gateway-cloudwatch" {
  name        = "apigw-cloudwatch-role-${var.api_name}"
  description = "AWS API Gateway - CloudWatch role."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "APIGatewayGrantAssumeRoleRights"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "api-gateway-push-to-cloudwatch-logs" {
  # Allows API Gateway to push logs to user's account.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  role       = aws_iam_role.api-gateway-cloudwatch.name
}

resource "aws_lambda_permission" "this" {
  count = var.lambda_function_name != null ? 1 : 0

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_stage.this.execution_arn}/*/*"
}