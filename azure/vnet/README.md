# Azure VNET Module

## Usage

```hcl
module "vnet-with-subnets" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/vnet?ref=main"

  name                  = "vnet-example-dev"
  create_resource_group = true
  resource_group_name   = "rg-vnet-example-dev"
  location              = "West Europe"
  address_space         = "10.0.0.0/16"
  subnet_configuration  = [
    {
      subnet_name               = "snet-example1"
      new_bits                  = 8
      service_endpoints         = ["Microsoft.KeyVault"]
      nat_gateway_id            = null
      network_security_group_id = null
      route_table_id            = null
    },
    {
      subnet_name               = "snet-example2"
      new_bits                  = 8
      nat_gateway_id            = null
      network_security_group_id = null
      route_table_id            = null
    },
  ]
}
```

If help is needed for calculating subnets, start [here](https://www.site24x7.com/tools/ipv4-subnetcalculator.html). Additionally, there is great Linux tool called `ipcalc` that can provide a full view with in-depth explanation. See the following examples:

Typing `ipcalc 10.0.0.0/16` will produce a summary:

```shell
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

```shell
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space that is used for the virtual network. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Indicates whether or not to create a resource group. | `bool` | `true` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of IP addresses of DNS servers. | `list(string)` | `[]` | no |
| <a name="input_enforce_private_link_endpoint_network_policies"></a> [enforce\_private\_link\_endpoint\_network\_policies](#input\_enforce\_private\_link\_endpoint\_network\_policies) | Enable or Disable network policies for the private link endpoint on the subnet. Setting this to true will Disable the policy and setting this to false will Enable the policy. Network policies, like network security groups (NSG), are not supported for Private Link Endpoints or Private Link Services. In order to deploy a Private Link Endpoint on a given subnet, you must set the enforce\_private\_link\_endpoint\_network\_policies attribute to true. This setting is only applicable for the Private Link Endpoint, for all other resources in the subnet access is controlled based via the Network Security Group. | `bool` | `false` | no |
| <a name="input_enforce_private_link_service_network_policies"></a> [enforce\_private\_link\_service\_network\_policies](#input\_enforce\_private\_link\_service\_network\_policies) | Enable or Disable network policies for the private link service on the subnet. Setting this to true will Disable the policy and setting this to false will Enable the policy. In order to deploy a Private Link Service on a given subnet, you must set the enforce\_private\_link\_service\_network\_policies attribute to true. This setting is only applicable for the Private Link Service, for all other resources in the subnet access is controlled based on the Network Security Group. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the virtual network. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group. | `string` | n/a | yes |
| <a name="input_subnet_configuration"></a> [subnet\_configuration](#input\_subnet\_configuration) | Sets the configuration for the subnet. For attributes nat\_gateway\_id, network\_security\_group\_id and route\_table\_id, set to null if not needed. The new\_bits attribute is the number of additional bits with which to extend the prefix. For example, if given a prefix ending in /16 and a new\_bits value of 88, the resulting subnet address will have length /24. | <pre>list(object({<br>    subnet_name               = string<br>    new_bits                  = number<br>    service_endpoints         = optional(list(string))<br>    nat_gateway_id            = string<br>    network_security_group_id = string<br>    route_table_id            = string<br>  }))</pre> | <pre>[<br>  {<br>    "nat_gateway_id": null,<br>    "network_security_group_id": null,<br>    "new_bits": 8,<br>    "route_table_id": null,<br>    "service_endpoints": null,<br>    "subnet_name": "snet-default"<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | n/a |
| <a name="output_subnet_ids_and_address_info"></a> [subnet\_ids\_and\_address\_info](#output\_subnet\_ids\_and\_address\_info) | n/a |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | n/a |
<!-- END_TF_DOCS -->