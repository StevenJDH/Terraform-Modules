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

resource "aws_iam_role" "this" {
  name        = "eventbridge-pipe-role-${local.pipe_name}"
  description = "EventBridge Pipe - Example role."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PipesGrantAssumeRoleRights"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "pipes.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.current_account_id
            "aws:SourceArn"     = "arn:aws:pipes:${var.region}:${local.current_account_id}:pipe/${local.pipe_name}"
          }
        }
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "dynamodb-pipe-source" {
  name        = "DynamoDbPipeSource-Example-${local.stage}"
  path        = "/"
  description = "Provides access to read from the DynamoDB Stream."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ]
        Resource = module.db-table.dynamodb_table_stream_arn
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "sns-pipe-target" {
  name        = "SnsPipeTarget-Example-${local.stage}"
  path        = "/"
  description = "Provides access to the SNS Topic."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = module.sns-topic.sns_topic_arns[0]
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "dynamodb-pipe-source" {
  policy_arn = aws_iam_policy.dynamodb-pipe-source.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "sns-pipe-target" {
  policy_arn = aws_iam_policy.sns-pipe-target.arn
  role       = aws_iam_role.this.name
}