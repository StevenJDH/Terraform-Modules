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
 
# https://github.com/hashicorp/terraform-provider-aws/issues/28153
resource "aws_cloudformation_stack" "this" {
  name = var.name

  parameters = {
    RoleArn   = var.eventbridge_pipe_role_arn
    SourceArn = var.event_source_arn
    TargetArn = var.event_target_arn
  }

  template_body = jsonencode({
    Parameters = {
      SourceArn = {
        Type = "String"
      }
      TargetArn = {
        Type = "String"
      }
      RoleArn = {
        Type = "String"
      }
    }
    Resources = {
      EventPipe = {
        Type = "AWS::Pipes::Pipe"
        Properties = {
          Name = var.name
          Description = var.description
          RoleArn = {
            Ref = "RoleArn"
          }
          Source = {
            Ref = "SourceArn"
          }
          SourceParameters = var.event_source_parameters
          Target = {
            Ref = "TargetArn"
          }
          TargetParameters = var.event_target_parameters
          Tags = var.tags
        }
      }
    }
    Outputs = {
      PipeArn = {
        Description = "ARN of the EventBridge Pipe."
        Value = {
          "Fn::GetAtt" = ["EventPipe", "Arn"]
        }
      }
    }
  })

  tags = var.tags
}