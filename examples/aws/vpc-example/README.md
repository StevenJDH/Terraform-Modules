# AWS VPC Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc-example"></a> [vpc-example](#module\_vpc-example) | ../../../aws/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_egress_only_internet_gateway_id"></a> [egress\_only\_internet\_gateway\_id](#output\_egress\_only\_internet\_gateway\_id) | n/a |
| <a name="output_eip_public_nat_ids"></a> [eip\_public\_nat\_ids](#output\_eip\_public\_nat\_ids) | n/a |
| <a name="output_internet_gateway_arn"></a> [internet\_gateway\_arn](#output\_internet\_gateway\_arn) | n/a |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | n/a |
| <a name="output_private_nat_ids"></a> [private\_nat\_ids](#output\_private\_nat\_ids) | n/a |
| <a name="output_public_nat_ids"></a> [public\_nat\_ids](#output\_public\_nat\_ids) | n/a |
| <a name="output_route_table_gateway_arns"></a> [route\_table\_gateway\_arns](#output\_route\_table\_gateway\_arns) | n/a |
| <a name="output_route_table_gateway_ids"></a> [route\_table\_gateway\_ids](#output\_route\_table\_gateway\_ids) | n/a |
| <a name="output_route_table_private_arns"></a> [route\_table\_private\_arns](#output\_route\_table\_private\_arns) | n/a |
| <a name="output_route_table_private_gateway_arns"></a> [route\_table\_private\_gateway\_arns](#output\_route\_table\_private\_gateway\_arns) | n/a |
| <a name="output_route_table_private_gateway_ids"></a> [route\_table\_private\_gateway\_ids](#output\_route\_table\_private\_gateway\_ids) | n/a |
| <a name="output_route_table_private_ids"></a> [route\_table\_private\_ids](#output\_route\_table\_private\_ids) | n/a |
| <a name="output_subnet_ids_and_address_info"></a> [subnet\_ids\_and\_address\_info](#output\_subnet\_ids\_and\_address\_info) | n/a |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | n/a |
| <a name="output_vpc_default_network_acl_id"></a> [vpc\_default\_network\_acl\_id](#output\_vpc\_default\_network\_acl\_id) | n/a |
| <a name="output_vpc_default_route_table_id"></a> [vpc\_default\_route\_table\_id](#output\_vpc\_default\_route\_table\_id) | n/a |
| <a name="output_vpc_default_security_group_id"></a> [vpc\_default\_security\_group\_id](#output\_vpc\_default\_security\_group\_id) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vpc_ipv6_association_id"></a> [vpc\_ipv6\_association\_id](#output\_vpc\_ipv6\_association\_id) | n/a |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | n/a |
<!-- END_TF_DOCS -->