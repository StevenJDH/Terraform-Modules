# AWS REST API Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.34.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_custom-domain-rest-api"></a> [custom-domain-rest-api](#module\_custom-domain-rest-api) | ../../../aws/rest-api | n/a |
| <a name="module_private-rest-api"></a> [private-rest-api](#module\_private-rest-api) | ../../../aws/rest-api | n/a |
| <a name="module_public-rest-api"></a> [public-rest-api](#module\_public-rest-api) | ../../../aws/rest-api | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of a VPC containing a VPC Endpoint for API Gateway. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_domain_cloudwatch_log_group_info"></a> [custom\_domain\_cloudwatch\_log\_group\_info](#output\_custom\_domain\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_custom_domain_curl_custom_domain_url"></a> [custom\_domain\_curl\_custom\_domain\_url](#output\_custom\_domain\_curl\_custom\_domain\_url) | n/a |
| <a name="output_custom_domain_curl_stage_invoke_url"></a> [custom\_domain\_curl\_stage\_invoke\_url](#output\_custom\_domain\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_custom_domain_execution_arn_for_lambda"></a> [custom\_domain\_execution\_arn\_for\_lambda](#output\_custom\_domain\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_custom_domain_rest_api_arn"></a> [custom\_domain\_rest\_api\_arn](#output\_custom\_domain\_rest\_api\_arn) | n/a |
| <a name="output_custom_domain_rest_api_id"></a> [custom\_domain\_rest\_api\_id](#output\_custom\_domain\_rest\_api\_id) | n/a |
| <a name="output_private_cloudwatch_log_group_info"></a> [private\_cloudwatch\_log\_group\_info](#output\_private\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_private_curl_custom_domain_url"></a> [private\_curl\_custom\_domain\_url](#output\_private\_curl\_custom\_domain\_url) | n/a |
| <a name="output_private_curl_stage_invoke_url"></a> [private\_curl\_stage\_invoke\_url](#output\_private\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_private_execution_arn_for_lambda"></a> [private\_execution\_arn\_for\_lambda](#output\_private\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_private_rest_api_arn"></a> [private\_rest\_api\_arn](#output\_private\_rest\_api\_arn) | n/a |
| <a name="output_private_rest_api_id"></a> [private\_rest\_api\_id](#output\_private\_rest\_api\_id) | n/a |
| <a name="output_public_cloudwatch_log_group_info"></a> [public\_cloudwatch\_log\_group\_info](#output\_public\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_public_curl_custom_domain_url"></a> [public\_curl\_custom\_domain\_url](#output\_public\_curl\_custom\_domain\_url) | n/a |
| <a name="output_public_curl_stage_invoke_url"></a> [public\_curl\_stage\_invoke\_url](#output\_public\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_public_execution_arn_for_lambda"></a> [public\_execution\_arn\_for\_lambda](#output\_public\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_public_rest_api_arn"></a> [public\_rest\_api\_arn](#output\_public\_rest\_api\_arn) | n/a |
| <a name="output_public_rest_api_id"></a> [public\_rest\_api\_id](#output\_public\_rest\_api\_id) | n/a |
<!-- END_TF_DOCS -->