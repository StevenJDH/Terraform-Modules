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

  lambda_stage_variables = {
    lambda_name = "lambda-api-backend-${local.stage}"
  }

  lambda_proxy_api_spec = jsonencode({
    openapi = "3.0.1"
    info = {
      title       = "overridden by api_name"
      description = "This is an example API."
      version     = "1.0.0"
    }
    "paths" = {
      "/v1/greet" = {
        get = {
          summary = "Gets a generic or personalized greeting."
          x-amazon-apigateway-integration = {
            httpMethod           = "POST" # For Lambda integrations, you must use the HTTP method of POST for the integration request.
            payloadFormatVersion = "1.0"
            type                 = "aws_proxy" # Proxy integrations cannot be configured to transform responses.
            passthroughBehavior  = "when_no_match"
            uri                  = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:$${stageVariables.lambda_name}/invocations" # Dollar symbol needs to be escaped as such.
          }
          parameters = [
            {
              name     = "person"
              in       = "query"
              required = false
              type     = "string"
            }
          ]
          responses = {
            200 = {
              description = "OK"
            }
            400 = {
              description = "Bad Request"
            }
            415 = {
              description = "Unsupported Media Type"
            }
            500 = {
              description = "Internal Server Error"
            }
          }
        }
      }
    }
  })

  lambda_integration_api_spec = jsonencode({
    openapi = "3.0.1"
    info = {
      title       = "overridden by api_name"
      description = "This is an example API."
      version     = "1.0.0"
    }
    "paths" = {
      "/v1/greet" = {
        get = {
          summary = "Gets a generic or personalized greeting."
          x-amazon-apigateway-integration = {
            httpMethod           = "POST" # For Lambda integrations, you must use the HTTP method of POST for the integration request.
            payloadFormatVersion = "1.0"
            type                 = "aws" # Supports transforming responses.
            passthroughBehavior  = "when_no_templates"
            uri                  = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:$${stageVariables.lambda_name}/invocations" # Dollar symbol needs to be escaped as such.
            requestTemplates = {
              # Translates the person query string parameter to the person property of the JSON payload.
              # This is necessary because input to a Lambda function must be expressed in the body.
              "application/json" = "{\"person\":\"$input.params('person')\"}"
            }
            responses : {
              default = {
                statusCode = "200"
                responseTemplates = {
                  "application/json" = "#set ($root=$input.path('$')) { \"greeting\": \"$root.body\" }"
                }
              }
              ".*.4\\d{2}.*" = {
                statusCode = "400"
                responseTemplates = {
                  "application/json" = "#set ($errorMessageObj=$util.parseJson($input.path('$.errorMessage'))) { \"body\":\"$errorMessageObj.body\",\"statusCode\":$errorMessageObj.statusCode }"
                }
              }
              ".*.5\\d{2}.*" = {
                statusCode = "500"
                responseTemplates = {
                  "application/json" = "#set ($errorMessageObj=$util.parseJson($input.path('$.errorMessage'))) { \"body\":\"$errorMessageObj.body\",\"statusCode\":$errorMessageObj.statusCode }"
                }
              }
            }
          }
          parameters = [
            {
              name     = "person"
              in       = "query"
              required = false
              type     = "string"
            }
          ]
          responses = {
            200 = {
              description = "OK"
            }
            400 = {
              description = "Bad Request"
            }
            415 = {
              description = "Unsupported Media Type"
            }
            500 = {
              description = "Internal Server Error"
            }
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