# AWS Lambda Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.32.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs-lambda"></a> [efs-lambda](#module\_efs-lambda) | ../../../aws/lambda | n/a |
| <a name="module_simple-lambda"></a> [simple-lambda](#module\_simple-lambda) | ../../../aws/lambda | n/a |
| <a name="module_vpc-lambda"></a> [vpc-lambda](#module\_vpc-lambda) | ../../../aws/lambda | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_access_point) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_efs_access_point_id"></a> [efs\_access\_point\_id](#input\_efs\_access\_point\_id) | ID that identifies the EFS access point. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs to associate with the Lambda function. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs to associate with the Lambda function. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_lambda_cloudwatch_log_group_info"></a> [efs\_lambda\_cloudwatch\_log\_group\_info](#output\_efs\_lambda\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_efs_lambda_function_details"></a> [efs\_lambda\_function\_details](#output\_efs\_lambda\_function\_details) | n/a |
| <a name="output_efs_lambda_invoked_lambda_response"></a> [efs\_lambda\_invoked\_lambda\_response](#output\_efs\_lambda\_invoked\_lambda\_response) | n/a |
| <a name="output_simple_lambda_cloudwatch_log_group_info"></a> [simple\_lambda\_cloudwatch\_log\_group\_info](#output\_simple\_lambda\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_simple_lambda_function_details"></a> [simple\_lambda\_function\_details](#output\_simple\_lambda\_function\_details) | n/a |
| <a name="output_simple_lambda_invoked_lambda_response"></a> [simple\_lambda\_invoked\_lambda\_response](#output\_simple\_lambda\_invoked\_lambda\_response) | n/a |
| <a name="output_vpc_lambda_cloudwatch_log_group_info"></a> [vpc\_lambda\_cloudwatch\_log\_group\_info](#output\_vpc\_lambda\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_vpc_lambda_function_details"></a> [vpc\_lambda\_function\_details](#output\_vpc\_lambda\_function\_details) | n/a |
| <a name="output_vpc_lambda_invoked_lambda_response"></a> [vpc\_lambda\_invoked\_lambda\_response](#output\_vpc\_lambda\_invoked\_lambda\_response) | n/a |
<!-- END_TF_DOCS -->