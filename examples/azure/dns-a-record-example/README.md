# Azure DNS A Record Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private-dns-a-record"></a> [private-dns-a-record](#module\_private-dns-a-record) | ../../../azure/dns-a-record | n/a |
| <a name="module_public-dns-a-record"></a> [public-dns-a-record](#module\_public-dns-a-record) | ../../../azure/dns-a-record | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | `"westeurope"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_dns_a_record_id"></a> [private\_dns\_a\_record\_id](#output\_private\_dns\_a\_record\_id) | n/a |
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | n/a |
| <a name="output_private_resource_group_id"></a> [private\_resource\_group\_id](#output\_private\_resource\_group\_id) | n/a |
| <a name="output_public_dns_a_record_id"></a> [public\_dns\_a\_record\_id](#output\_public\_dns\_a\_record\_id) | n/a |
| <a name="output_public_dns_zone_id"></a> [public\_dns\_zone\_id](#output\_public\_dns\_zone\_id) | n/a |
| <a name="output_public_resource_group_id"></a> [public\_resource\_group\_id](#output\_public\_resource\_group\_id) | n/a |
<!-- END_TF_DOCS -->