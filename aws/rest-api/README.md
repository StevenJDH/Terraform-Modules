# AWS REST API Module

## Feature highlights

* Create Public, Private, and Edge Optimized REST APIs using OpenAPI 3 Specifications. For more information, see [REST APIs vs HTTP APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-vs-rest.html).
* Support for OpenAPI 3 + API Gateway Extensions to apply more API Gateway specific configurations.
* Support for Apache Velocity Template Language (VTL) to define mapping and transformation templates.
* Create stage variables to avoid hard-coding information as a best practice.
* Support for defining a custom domain name for one or more API backends.
* Optionally use free, recognized certificates signed by Amazon with auto verification to enable HTTPS for custom domains.
* Optionally create Lambda resource-based policy statements to allow API Gateway to access a Lambda function.
* Automatically restrict private APIs to VPC Endpoints as a security best practice.
* Optionally capture and store logs, metrics, and request/response messages to CloudWatch.

## Usage

```hcl
#############################################################
## See example project for additional examples with Lambda ##
#############################################################

locals {
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
}

module "public-rest-api" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/rest-api?ref=main"

  api_name          = "public-api-example-dev"
  endpoint_type     = "REGIONAL"
  stage_name        = "dev"
  stage_variables   = { url = "ip-ranges.amazonaws.com/ip-ranges.json" }
  api_specification = local.api_spec
  
  cloudwatch_logging_level            = "ERROR"
  enable_cloudwatch_metrics           = true
  enable_request_and_response_logging = true
  cloudwatch_log_retention_in_days    = 7

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

module "private-rest-api" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/rest-api?ref=main"

  api_name          = "private-api-example-dev"
  endpoint_type     = "PRIVATE"
  stage_name        = "dev"
  stage_variables   = { url = "ip-ranges.amazonaws.com/ip-ranges.json" }
  vpc_endpoint_ids  = ["vpce-0123456789abcdef0"]
  api_specification = local.api_spec

  cloudwatch_logging_level            = "ERROR"
  enable_cloudwatch_metrics           = true
  enable_request_and_response_logging = true
  cloudwatch_log_retention_in_days    = 7

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

module "custom-domain-rest-api" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/rest-api?ref=main"

  api_name                 = "custom-domain-api-example-dev"
  endpoint_type            = "REGIONAL"
  stage_name               = "dev"
  stage_variables          = { url = "ip-ranges.amazonaws.com/ip-ranges.json" }
  enable_acm_custom_domain = true
  hosted_zone_id           = "ABCDEFGHIJK1234567890"
  api_root_domain_name     = "domain.com"
  api_subdomain_name       = "api-dev"
  api_specification        = local.api_spec

  cloudwatch_logging_level            = "ERROR"
  enable_cloudwatch_metrics           = true
  enable_request_and_response_logging = true
  cloudwatch_log_retention_in_days    = 7

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_api_gateway_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_api_gateway_base_path_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_deployment.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_api_gateway_method_settings.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_rest_api_policy.vpce-restricted](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy) | resource |
| [aws_api_gateway_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.api-gateway-cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.api-gateway-push-to-cloudwatch-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_domain_subdirectory"></a> [api\_domain\_subdirectory](#input\_api\_domain\_subdirectory) | The subdirectory that comes after the `api_root_domain_name`, for example, `myservice`. Slashes are not supported. | `string` | `null` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Name of the API Gateway REST API. This corresponds to the `info.title` field, and if the argument value is different than the OpenAPI value, the argument value will override the OpenAPI value. | `string` | n/a | yes |
| <a name="input_api_root_domain_name"></a> [api\_root\_domain\_name](#input\_api\_root\_domain\_name) | The root (apex) domain name for the API, for example, `domain.com`. See `api_subdomain_name` to set a custom subdomain. | `string` | `null` | no |
| <a name="input_api_specification"></a> [api\_specification](#input\_api\_specification) | OpenAPI specification that defines the set of routes and integrations to create as part of the REST API. Use `API` > `Stages` > `Export` > `OpenAPI 3 + API Gateway Extensions` JSON format, and remove the `servers` and `x-amazon-apigateway-policy` blocks if present. | `string` | n/a | yes |
| <a name="input_api_subdomain_name"></a> [api\_subdomain\_name](#input\_api\_subdomain\_name) | The subdomain name for the API, for example, `api`. See `api_root_domain_name` to set a custom root domain. | `string` | `"api"` | no |
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `90` | no |
| <a name="input_cloudwatch_logging_level"></a> [cloudwatch\_logging\_level](#input\_cloudwatch\_logging\_level) | Logging level for method, which effects the log entries pushed to Amazon CloudWatch Logs. The available levels are OFF, ERROR, and INFO. Prefer ERROR over INFO as a recommendation to save cost. | `string` | `"OFF"` | no |
| <a name="input_cloudwatch_role_arn_for_api_gateway"></a> [cloudwatch\_role\_arn\_for\_api\_gateway](#input\_cloudwatch\_role\_arn\_for\_api\_gateway) | ARN of an existing IAM role for CloudWatch to allow logging & monitoring in API Gateway. This is an account level setting, so either specify an existing ARN, or a new role will be created and used. | `string` | `null` | no |
| <a name="input_enable_acm_custom_domain"></a> [enable\_acm\_custom\_domain](#input\_enable\_acm\_custom\_domain) | Indicates whether or not to enable the use of a custom domain name for an API using a free certificate from AWS Certificate Manager (ACM). Requires a domain name to have been previously registered in AWS Route 53. | `bool` | `false` | no |
| <a name="input_enable_cloudwatch_metrics"></a> [enable\_cloudwatch\_metrics](#input\_enable\_cloudwatch\_metrics) | Indicates whether or not to enable CloudWatch Metrics. | `bool` | `false` | no |
| <a name="input_enable_request_and_response_logging"></a> [enable\_request\_and\_response\_logging](#input\_enable\_request\_and\_response\_logging) | Indicates whether or not to log full request/response data. | `bool` | `false` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | Type of endpoint to use for the API. Valid values are EDGE, REGIONAL and PRIVATE. | `string` | `"REGIONAL"` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | The identifier of the hosted zone to use for storing DNS records. Private hosted zones are not supported. | `string` | `null` | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | Name of a Lambda function where an additional resource-based policy statement will be added with access permissions for API Gateway. The permissions will allow invocations from any method and resource path for a specific stage within the API Gateway REST API. If more restrictive permissions are needed, then use instead the `execution_arn_for_lambda` output along with a `aws_lambda_permission` resource. | `string` | `null` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | Name of the stage. | `string` | n/a | yes |
| <a name="input_stage_variables"></a> [stage\_variables](#input\_stage\_variables) | A map that defines the stage variables to avoid hard-coding information. For more information, see [Setting up stage variables for a REST API deployment](https://docs.aws.amazon.com/apigateway/latest/developerguide/stage-variables.html). | `map(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_throttling_burst_limit"></a> [throttling\_burst\_limit](#input\_throttling\_burst\_limit) | Throttling burst limit. Setting this to -1 disables throttling. | `number` | `-1` | no |
| <a name="input_throttling_rate_limit"></a> [throttling\_rate\_limit](#input\_throttling\_rate\_limit) | Throttling rate limit. Setting this to -1 disables throttling. | `number` | `-1` | no |
| <a name="input_vpc_endpoint_ids"></a> [vpc\_endpoint\_ids](#input\_vpc\_endpoint\_ids) | Set of VPC Endpoint identifiers. Only supported for PRIVATE endpoint type. Requires the [VPC Endpoint](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/vpc-endpoint) module, or any other means to create the same. | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_info"></a> [cloudwatch\_log\_group\_info](#output\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_curl_custom_domain_url"></a> [curl\_custom\_domain\_url](#output\_curl\_custom\_domain\_url) | n/a |
| <a name="output_curl_stage_invoke_url"></a> [curl\_stage\_invoke\_url](#output\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_execution_arn_for_lambda"></a> [execution\_arn\_for\_lambda](#output\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_rest_api_arn"></a> [rest\_api\_arn](#output\_rest\_api\_arn) | n/a |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | n/a |
<!-- END_TF_DOCS -->