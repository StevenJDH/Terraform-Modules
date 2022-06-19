# Azure Key Vault Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.10.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private-key-vault"></a> [private-key-vault](#module\_private-key-vault) | ../../../azure/key-vault | n/a |
| <a name="module_public-key-vault"></a> [public-key-vault](#module\_public-key-vault) | ../../../azure/key-vault | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subnet.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | `"West Europe"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_endpoint_ip_address"></a> [private\_endpoint\_ip\_address](#output\_private\_endpoint\_ip\_address) | n/a |
| <a name="output_private_key_vault_id"></a> [private\_key\_vault\_id](#output\_private\_key\_vault\_id) | n/a |
| <a name="output_private_key_vault_resource_group_id"></a> [private\_key\_vault\_resource\_group\_id](#output\_private\_key\_vault\_resource\_group\_id) | n/a |
| <a name="output_private_key_vault_uri"></a> [private\_key\_vault\_uri](#output\_private\_key\_vault\_uri) | n/a |
| <a name="output_privatelink_dns_a_record_id"></a> [privatelink\_dns\_a\_record\_id](#output\_privatelink\_dns\_a\_record\_id) | n/a |
| <a name="output_privatelink_dns_zone_id"></a> [privatelink\_dns\_zone\_id](#output\_privatelink\_dns\_zone\_id) | n/a |
| <a name="output_privatelink_resource_group_id"></a> [privatelink\_resource\_group\_id](#output\_privatelink\_resource\_group\_id) | n/a |
| <a name="output_public_key_vault_id"></a> [public\_key\_vault\_id](#output\_public\_key\_vault\_id) | n/a |
| <a name="output_public_key_vault_resource_group_id"></a> [public\_key\_vault\_resource\_group\_id](#output\_public\_key\_vault\_resource\_group\_id) | n/a |
| <a name="output_public_key_vault_uri"></a> [public\_key\_vault\_uri](#output\_public\_key\_vault\_uri) | n/a |
<!-- END_TF_DOCS -->