# Azure DNS A Record Module

## Usage

```hcl
module "private-dns-a-record" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/dns-a-record?ref=main"

  create_dns_zone                   = true
  dns_zone_name                     = "example.com"
  dns_a_record_name                 = "test"
  ip_address_for_a_record           = "10.55.55.55"
  location                          = "westeurope"
  create_resource_group             = true
  resource_group_name               = "rg-private-dns-a-record-example-dev"
  create_private_dns_zone_vnet_link = true
  virtual_network_id                = data.azurerm_virtual_network.example.id            
}

module "public-dns-a-record" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/dns-a-record?ref=main"

  private_dns_record      = false
  create_dns_zone         = true
  dns_zone_name           = "example.com"
  dns_a_record_name       = "test"
  ip_address_for_a_record = "99.55.55.55"
  location                = "westeurope"
  create_resource_group   = true
  resource_group_name     = "rg-public-dns-a-record-example-dev"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
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
| [azurerm_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_dns_zone.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_private_dns_zone.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_dns_zone"></a> [create\_dns\_zone](#input\_create\_dns\_zone) | Indicates whether or not to create a DNS zone. | `bool` | `false` | no |
| <a name="input_create_private_dns_zone_vnet_link"></a> [create\_private\_dns\_zone\_vnet\_link](#input\_create\_private\_dns\_zone\_vnet\_link) | Indicates whether or not to create a private DNS zone virtual network link. | `bool` | `false` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Indicates whether or not to create a resource group. | `bool` | `true` | no |
| <a name="input_dns_a_record_name"></a> [dns\_a\_record\_name](#input\_dns\_a\_record\_name) | Name of DNS A record. | `string` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | Name of DNS zone. | `string` | n/a | yes |
| <a name="input_enable_auto_registration"></a> [enable\_auto\_registration](#input\_enable\_auto\_registration) | Indicates whether or not to enable auto-registration of virtual machine records in the virtual network in the Private DNS zone. | `bool` | `true` | no |
| <a name="input_ip_address_for_a_record"></a> [ip\_address\_for\_a\_record](#input\_ip\_address\_for\_a\_record) | IP address for private DNS A record. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_private_dns_record"></a> [private\_dns\_record](#input\_private\_dns\_record) | Indicates whether or not this is for a private DNS A record. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL for private DNS A record. | `number` | `3600` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | Virtual network Id for private DNS zone virtual network link. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_dns_a_record_id"></a> [private\_dns\_a\_record\_id](#output\_private\_dns\_a\_record\_id) | n/a |
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | n/a |
| <a name="output_public_dns_a_record_id"></a> [public\_dns\_a\_record\_id](#output\_public\_dns\_a\_record\_id) | n/a |
| <a name="output_public_dns_zone_id"></a> [public\_dns\_zone\_id](#output\_public\_dns\_zone\_id) | n/a |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | n/a |
<!-- END_TF_DOCS -->