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
  stage       = "dev"
  aws_profile = "default"

  stage_variables = {
    url = "ip-ranges.amazonaws.com/ip-ranges.json"
  }

  api_spec = jsonencode({
    openapi = "3.0.1"
    info = {
      title       = "overridden by api_name"
      description = "This is an example API."
      version     = "1.0.0"
    }
    paths = {
      "/v1/example" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://$${stageVariables.url}" # Dollar symbol needs to be escaped as such.
          }
        }
      }
    }
  })

  tags = {
    environment = local.stage
    terraform   = true
  }
}