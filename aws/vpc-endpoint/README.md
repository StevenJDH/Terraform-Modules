# AWS VPC Endpoint Module

## Usage

```hcl
module "vpce-interface-example" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/vpc-endpoint?ref=main"

  name               = "ssm-vpce-example-dev"
  vpc_id             = "vpc-1234abcd"
  service_name       = "com.amazonaws.eu-west-3.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = ["subnet-1234abcd",]

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

module "vpce-gateway-lb-example" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/vpc-endpoint?ref=main"

  name                       = "gateway-lb-vpce-example-dev"
  vpc_id                     = "vpc-1234abcd"
  vpc_endpoint_type          = "GatewayLoadBalancer"
  subnet_ids                 = ["subnet-1234abcd",]
  gateway_load_balancer_arns = [
    "arn:aws:elasticloadbalancing:eu-west-3:123456789012:loadbalancer/gwy/my-lb/1234567890123456",
  ]

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
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
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_service.gateway-lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_record_ip_type"></a> [dns\_record\_ip\_type](#input\_dns\_record\_ip\_type) | The DNS records created for the endpoint. Only used when `enable_private_dns` is `true`. Valid values are ipv4, dualstack, service-defined, and ipv6. | `string` | `"ipv4"` | no |
| <a name="input_enable_private_dns"></a> [enable\_private\_dns](#input\_enable\_private\_dns) | Indicates whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface for AWS services and AWS Marketplace partner services only. | `bool` | `true` | no |
| <a name="input_gateway_load_balancer_arns"></a> [gateway\_load\_balancer\_arns](#input\_gateway\_load\_balancer\_arns) | ARNs of one or more Gateway Load Balancers for the endpoint service. Applicable for endpoints of type GatewayLoadBalancer. | `list(string)` | `[]` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The IP address type for the endpoint. Valid values are ipv4, dualstack, and ipv6. | `string` | `"ipv4"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the PrivateLink. | `string` | n/a | yes |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | One or more route table IDs. Applicable for endpoints of type Gateway. | `list(string)` | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint. | `list(string)` | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The service name. For AWS services, the service name is usually in the form `com.amazonaws.<region>.<service>` (the SageMaker Notebook service is an exception to this rule, the service name is in the form `aws.sagemaker.<region>.notebook`). See [AWS services that integrate with AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html) for more details. Not providing a value for endpoints of type GatewayLoadBalancer creates a new endpoint service that will be used. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `null` | no |
| <a name="input_vpc_endpoint_type"></a> [vpc\_endpoint\_type](#input\_vpc\_endpoint\_type) | The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface. | `string` | `"Gateway"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which the endpoint will be used. | `string` | n/a | yes |
| <a name="input_vpce_svc_tags"></a> [vpce\_svc\_tags](#input\_vpce\_svc\_tags) | Additional tags for the GatewayLoadBalancer PrivateLink Service. | `map(string)` | `null` | no |
| <a name="input_vpce_tags"></a> [vpce\_tags](#input\_vpce\_tags) | Additional tags for the PrivateLink. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway_lb_vpce_svc_arn"></a> [gateway\_lb\_vpce\_svc\_arn](#output\_gateway\_lb\_vpce\_svc\_arn) | n/a |
| <a name="output_gateway_lb_vpce_svc_id"></a> [gateway\_lb\_vpce\_svc\_id](#output\_gateway\_lb\_vpce\_svc\_id) | n/a |
| <a name="output_gateway_lb_vpce_svc_name"></a> [gateway\_lb\_vpce\_svc\_name](#output\_gateway\_lb\_vpce\_svc\_name) | n/a |
| <a name="output_vpce_arn"></a> [vpce\_arn](#output\_vpce\_arn) | n/a |
| <a name="output_vpce_id"></a> [vpce\_id](#output\_vpce\_id) | n/a |
<!-- END_TF_DOCS -->