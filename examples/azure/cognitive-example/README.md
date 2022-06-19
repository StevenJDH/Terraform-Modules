# Azure Cognitive Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_cognitive_tts"></a> [private\_cognitive\_tts](#module\_private\_cognitive\_tts) | ../../../azure/cognitive | n/a |
| <a name="module_public_cognitive_tts"></a> [public\_cognitive\_tts](#module\_public\_cognitive\_tts) | ../../../azure/cognitive | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | `"West Europe"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_cognitive_id"></a> [private\_cognitive\_id](#output\_private\_cognitive\_id) | n/a |
| <a name="output_private_endpoint_ip_address"></a> [private\_endpoint\_ip\_address](#output\_private\_endpoint\_ip\_address) | n/a |
| <a name="output_private_primary_access_key"></a> [private\_primary\_access\_key](#output\_private\_primary\_access\_key) | n/a |
| <a name="output_private_resource_group_id"></a> [private\_resource\_group\_id](#output\_private\_resource\_group\_id) | n/a |
| <a name="output_private_secondary_access_key"></a> [private\_secondary\_access\_key](#output\_private\_secondary\_access\_key) | n/a |
| <a name="output_private_service_endpoint"></a> [private\_service\_endpoint](#output\_private\_service\_endpoint) | n/a |
| <a name="output_public_cognitive_id"></a> [public\_cognitive\_id](#output\_public\_cognitive\_id) | n/a |
| <a name="output_public_primary_access_key"></a> [public\_primary\_access\_key](#output\_public\_primary\_access\_key) | n/a |
| <a name="output_public_resource_group_id"></a> [public\_resource\_group\_id](#output\_public\_resource\_group\_id) | n/a |
| <a name="output_public_secondary_access_key"></a> [public\_secondary\_access\_key](#output\_public\_secondary\_access\_key) | n/a |
| <a name="output_public_service_endpoint"></a> [public\_service\_endpoint](#output\_public\_service\_endpoint) | n/a |
<!-- END_TF_DOCS -->