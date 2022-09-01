# AWS VPC Endpoint Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpce-gateway-lb-example"></a> [vpce-gateway-lb-example](#module\_vpce-gateway-lb-example) | ../../../aws/vpc-endpoint | n/a |
| <a name="module_vpce-interface-example"></a> [vpce-interface-example](#module\_vpce-interface-example) | ../../../aws/vpc-endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb.selected-gateway-lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gateway_lb_arn"></a> [gateway\_lb\_arn](#input\_gateway\_lb\_arn) | ARN of the specific gateway load balancer to retrieve. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the specific subnet to retrieve. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the specific VPC to retrieve. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway_lb_vpce_arn"></a> [gateway\_lb\_vpce\_arn](#output\_gateway\_lb\_vpce\_arn) | n/a |
| <a name="output_gateway_lb_vpce_id"></a> [gateway\_lb\_vpce\_id](#output\_gateway\_lb\_vpce\_id) | n/a |
| <a name="output_gateway_lb_vpce_svc_arn"></a> [gateway\_lb\_vpce\_svc\_arn](#output\_gateway\_lb\_vpce\_svc\_arn) | n/a |
| <a name="output_gateway_lb_vpce_svc_id"></a> [gateway\_lb\_vpce\_svc\_id](#output\_gateway\_lb\_vpce\_svc\_id) | n/a |
| <a name="output_gateway_lb_vpce_svc_name"></a> [gateway\_lb\_vpce\_svc\_name](#output\_gateway\_lb\_vpce\_svc\_name) | n/a |
| <a name="output_ssm_vpce_arn"></a> [ssm\_vpce\_arn](#output\_ssm\_vpce\_arn) | n/a |
| <a name="output_ssm_vpce_id"></a> [ssm\_vpce\_id](#output\_ssm\_vpce\_id) | n/a |
<!-- END_TF_DOCS -->