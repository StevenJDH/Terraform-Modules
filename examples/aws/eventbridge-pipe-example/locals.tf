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

locals {
  stage              = "dev"
  aws_profile        = "default"
  current_account_id = data.aws_caller_identity.current.account_id
  pipe_name          = "tf-pipe-example-${local.stage}"

  event_source_parameters = {
    DynamoDBStreamParameters = {
      BatchSize        = 1
      StartingPosition = "LATEST"
    }
    FilterCriteria = {
      Filters = [
        {
          Pattern = jsonencode({eventName=[{prefix="INSERT"}]})
        },
      ]
    }
  }

  event_target_parameters = {
    InputTemplate = <<-EOF
    {
      "pipeName" : <aws.pipes.pipe-name>,
      "eventName": "<$.eventName>",
      "ingestionTime": <aws.pipes.event.ingestion-time>,
      "eventSource": <$.eventSource>,
      "awsRegion": <$.awsRegion>,
      "customerId": <$.dynamodb.NewImage.pk_customer_id.S>,
      "orderDate": <$.dynamodb.NewImage.sk_order_date.S>,
      "orderId": <$.dynamodb.NewImage.order_id.S>
    }
    EOF
  }

  tags = {
    environment = local.stage
    terraform   = true
  }
}