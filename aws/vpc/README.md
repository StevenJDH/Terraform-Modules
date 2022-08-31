# AWS VPC Module

## Feature highlights

* Support for multiple subnet use cases, including high availability and automatic route table configuration.
* Includes many best practices being baked into the setup.
* Smart resource naming and tagging strategies, including default resources.
* Support for PrivateLink use cases and other VPC dependent services like EKS.
* Automatic subnetting using just a bit number to help prevent miscalculations.

**Note:** For multiple NATs across different AZs for high availability, each private subnet will point to its paired public subnet or the last one listed. For example, the first listed private subnet will point to the first listed public subnet with a public NAT and so on.

## Usage

```hcl
module "vpc-example" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/vpc?ref=main"

  name                                = "network-example-dev"
  enable_ipv6                         = true
  create_egress_only_internet_gateway = true
  create_internet_gateway             = true
  single_private_route_table          = true
  single_public_route_table           = true
  subnet_configuration                = [
    {
      subnet_name               = "snet-example1"
      new_bits                  = 8
      availability_zone         = "a"
      make_public               = true
      create_nat_gateway        = true
    },
    {
      new_bits                  = 8
      availability_zone         = "b"
      make_public               = true
      create_nat_gateway        = false
    },
    {
      new_bits                  = 8
      availability_zone         = "c"
      make_public               = false
      create_nat_gateway        = true
    },
  ]

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}
```

If help is needed for calculating subnets, start [here](https://www.site24x7.com/tools/ipv4-subnetcalculator.html). Additionally, there is great Linux tool called `ipcalc` that can provide a full view with in-depth explanation. See the following examples:

Typing `ipcalc 10.0.0.0/16` will produce a summary:

```bash
Address:   192.168.0.0          11000000.10101000.00000000. 00000000
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   192.168.0.0/24       11000000.10101000.00000000. 00000000
HostMin:   192.168.0.1          11000000.10101000.00000000. 00000001
HostMax:   192.168.0.254        11000000.10101000.00000000. 11111110
Broadcast: 192.168.0.255        11000000.10101000.00000000. 11111111
Hosts/Net: 254                   Class C, Private Internet
```

And typing `ipcalc 10.0.0.0/16 /24` will produce a breakdown based on the choosing prefix size:

```bash
Subnets after transition from /16 to /24

Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111

 1.
Network:   10.0.0.0/24          00001010.00000000.00000000. 00000000
HostMin:   10.0.0.1             00001010.00000000.00000000. 00000001
HostMax:   10.0.0.254           00001010.00000000.00000000. 11111110
Broadcast: 10.0.0.255           00001010.00000000.00000000. 11111111
Hosts/Net: 254                   Class A, Private Internet

 2.
Network:   10.0.1.0/24          00001010.00000000.00000001. 00000000
HostMin:   10.0.1.1             00001010.00000000.00000001. 00000001
HostMax:   10.0.1.254           00001010.00000000.00000001. 11111110
Broadcast: 10.0.1.255           00001010.00000000.00000001. 11111111
Hosts/Net: 254                   Class A, Private Internet

 3...
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
| [aws_default_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_default_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_egress_only_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.default-priv-2-egress-only-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.default-priv-2-pub-ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.gateway-ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.gateway-ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.priv-2-egress-only-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.priv-2-pub-ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_default_routes"></a> [add\_default\_routes](#input\_add\_default\_routes) | Indicates whether or not to add default routes when possible to a public NAT in the default route table or any private route tables, and the Internet Gateway to any gateway route tables. | `bool` | `true` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The IPv4 CIDR block for the VPC. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_create_egress_only_internet_gateway"></a> [create\_egress\_only\_internet\_gateway](#input\_create\_egress\_only\_internet\_gateway) | Indicates whether or not to create an Egress Only Internet Gateway for private subnets with support for IPv6 addresses. The enable\_ipv6 attribute must also be set to true. | `bool` | `false` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | Indicates whether or not to create an Internet Gateway for public subnets. Even if set to false, it will still be created if a public NAT is created. | `bool` | `false` | no |
| <a name="input_default_acl_egress_rules"></a> [default\_acl\_egress\_rules](#input\_default\_acl\_egress\_rules) | Configuration for default ACL egress rules. | <pre>list(object({<br>    rule_no         = number<br>    action          = string<br>    protocol        = number<br>    from_port       = number<br>    to_port         = number<br>    cidr_block      = optional(string)<br>    icmp_code       = optional(number)<br>    icmp_type       = optional(number)<br>    ipv6_cidr_block = optional(string)<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "icmp_code": null,<br>    "icmp_type": null,<br>    "ipv6_cidr_block": null,<br>    "protocol": -1,<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_acl_ingress_rules"></a> [default\_acl\_ingress\_rules](#input\_default\_acl\_ingress\_rules) | Configuration for default ACL ingress rules. | <pre>list(object({<br>    rule_no         = number<br>    action          = string<br>    protocol        = number<br>    from_port       = number<br>    to_port         = number<br>    cidr_block      = optional(string)<br>    icmp_code       = optional(number)<br>    icmp_type       = optional(number)<br>    ipv6_cidr_block = optional(string)<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "icmp_code": null,<br>    "icmp_type": null,<br>    "ipv6_cidr_block": null,<br>    "protocol": -1,<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_acl_tags"></a> [default\_acl\_tags](#input\_default\_acl\_tags) | Additional tags for the default ACL. | `map(string)` | `null` | no |
| <a name="input_default_private_route_table_tags"></a> [default\_private\_route\_table\_tags](#input\_default\_private\_route\_table\_tags) | Additional tags for the default private route table. | `map(string)` | `null` | no |
| <a name="input_default_security_group_egress_rules"></a> [default\_security\_group\_egress\_rules](#input\_default\_security\_group\_egress\_rules) | Configuration for default security group egress rules. | <pre>list(object({<br>    description      = optional(string)<br>    protocol         = string<br>    from_port        = number<br>    to_port          = number<br>    prefix_list_ids  = optional(list(string))<br>    security_groups  = optional(set(string))<br>    cidr_blocks      = optional(list(string))<br>    ipv6_cidr_blocks = optional(list(string))<br>    self             = optional(bool)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": null,<br>    "from_port": 0,<br>    "ipv6_cidr_blocks": null,<br>    "prefix_list_ids": null,<br>    "protocol": "-1",<br>    "security_groups": null,<br>    "self": null,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_security_group_ingress_rules"></a> [default\_security\_group\_ingress\_rules](#input\_default\_security\_group\_ingress\_rules) | Configuration for default security group ingress rules. | <pre>list(object({<br>    description      = optional(string)<br>    protocol         = string<br>    from_port        = number<br>    to_port          = number<br>    prefix_list_ids  = optional(list(string))<br>    security_groups  = optional(set(string))<br>    cidr_blocks      = optional(list(string))<br>    ipv6_cidr_blocks = optional(list(string))<br>    self             = optional(bool)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": null,<br>    "description": null,<br>    "from_port": 0,<br>    "ipv6_cidr_blocks": null,<br>    "prefix_list_ids": null,<br>    "protocol": "-1",<br>    "security_groups": null,<br>    "self": true,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_default_security_group_tags"></a> [default\_security\_group\_tags](#input\_default\_security\_group\_tags) | Additional tags for the default security group. | `map(string)` | `null` | no |
| <a name="input_eigw_tags"></a> [eigw\_tags](#input\_eigw\_tags) | Additional tags for the Egress Only Internet Gateway. | `map(string)` | `null` | no |
| <a name="input_eip_public_nat_tags"></a> [eip\_public\_nat\_tags](#input\_eip\_public\_nat\_tags) | Additional tags for the public NAT Gateway Elastic IP. | `map(string)` | `null` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Indicates whether or not to enable/disable DNS hostnames in the VPC. Required for PrivateLinks and EKS. | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Indicates whether or not to enable/disable DNS support in the VPC. | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. | `bool` | `false` | no |
| <a name="input_igw_route_table_tags"></a> [igw\_route\_table\_tags](#input\_igw\_route\_table\_tags) | Additional tags for the Internet Gateway route tables. | `map(string)` | `null` | no |
| <a name="input_igw_tags"></a> [igw\_tags](#input\_igw\_tags) | Additional tags for the Internet Gateway. | `map(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the VPC, which is also used as part of the name for all resources. | `string` | n/a | yes |
| <a name="input_private_ngw_route_table_tags"></a> [private\_ngw\_route\_table\_tags](#input\_private\_ngw\_route\_table\_tags) | Additional tags for the private NAT Gateway route tables. | `map(string)` | `null` | no |
| <a name="input_private_ngw_tags"></a> [private\_ngw\_tags](#input\_private\_ngw\_tags) | Additional tags for the private NAT Gateway. | `map(string)` | `null` | no |
| <a name="input_private_route_table_tags"></a> [private\_route\_table\_tags](#input\_private\_route\_table\_tags) | Additional tags for the private route tables. | `map(string)` | `null` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Additional tags for the private subnets. | `map(string)` | `null` | no |
| <a name="input_public_ngw_tags"></a> [public\_ngw\_tags](#input\_public\_ngw\_tags) | Additional tags for the public NAT Gateway. | `map(string)` | `null` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Additional tags for the public subnets. | `map(string)` | `null` | no |
| <a name="input_single_private_route_table"></a> [single\_private\_route\_table](#input\_single\_private\_route\_table) | Indicates whether or not to keep private subnets on the default route table, or provision each private subnet its own route table. | `bool` | `true` | no |
| <a name="input_single_public_route_table"></a> [single\_public\_route\_table](#input\_single\_public\_route\_table) | Indicates whether or not to provision a single shared route table for public subnets, or provision each public subnet its own route table. | `bool` | `true` | no |
| <a name="input_subnet_configuration"></a> [subnet\_configuration](#input\_subnet\_configuration) | Sets the private and public subnet configuration. Optionally override subnet name, choose the availability zone using letters a to c, mark the subnet as public or not, and add multiple private or public NAT Gateways as needed. The new\_bits attribute is the number of additional bits that defines the subnet's IPv4 CIDR block. For multiple NATs across different AZs for high availability, each private subnet will point to its paired public subnet or the last one listed. For example, the first listed private subnet will point to the first listed public subnet with a public NAT and so on. | <pre>list(object({<br>    subnet_name               = optional(string)<br>    new_bits                  = number<br>    availability_zone         = string<br>    make_public               = bool<br>    create_nat_gateway        = bool<br>  }))</pre> | <pre>[<br>  {<br>    "availability_zone": "a",<br>    "create_nat_gateway": false,<br>    "make_public": false,<br>    "new_bits": 8,<br>    "subnet_name": null<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `null` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Additional tags for the VPC. | `map(string)` | `null` | no |

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