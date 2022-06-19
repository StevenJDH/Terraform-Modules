# Azure Cognitive Module

## Usage

```hcl
module "public_cognitive_tts" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/cognitive?ref=main"

  name                  = "cog-public-tts-example-dev"
  create_resource_group = true
  resource_group_name   = "rg-public-cognitive-example-dev"
  location              = "westeurope"
  kind                  = "SpeechServices"
  sku_name              = "F0"
}

module "private_cognitive_tts" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/cognitive?ref=main"

  name                  = "cog-private-tts-example-dev"
  create_resource_group = true
  resource_group_name   = "rg-private-cognitive-example-dev"
  location              = "westeurope"
  kind                  = "SpeechServices"
  sku_name              = "F0"

  network_acls = {
    allow_when_no_acl_rules_match = false
    ip_rules                      = []
    subnet_id_for_service_rules   = data.azurerm_subnet.example.id
  }
  
  enable_public_or_selected_network_access = true
  custom_subdomain_name                    = "demo-acs"
  create_private_endpoint                  = true
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
| [azurerm_cognitive_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_private_endpoint"></a> [create\_private\_endpoint](#input\_create\_private\_endpoint) | Indicates whether or not to create a private endpoint. Required if enable\_public\_or\_selected\_network\_access is set to false as it will be the exclusive way to access this resource. | `bool` | `false` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Indicates whether or not to create a resource group. | `bool` | `true` | no |
| <a name="input_custom_subdomain_name"></a> [custom\_subdomain\_name](#input\_custom\_subdomain\_name) | The subdomain name used for token-based authentication. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_enable_public_or_selected_network_access"></a> [enable\_public\_or\_selected\_network\_access](#input\_enable\_public\_or\_selected\_network\_access) | Indicates whether or not public or selected network access is allowed for the Cognitive Account. If set to false, private endpoint connections will be the exclusive way to access this resource. | `bool` | `true` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | Specifies the type of Cognitive Service Account that should be created. You must create your first Face, Text Analytics, or Computer Vision resources from the Azure portal to review and acknowledge the terms and conditions. In Azure Portal, the checkbox to accept terms and conditions is only displayed when a US region is selected. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the Cognitive Service Account. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Specifies what default action to use when no rules match from ip\_rules / virtual\_network\_rules, and One or more IP Addresses, or CIDR Blocks which should be able to access the Cognitive Account. | <pre>object({<br>    allow_when_no_acl_rules_match = bool,<br>    ip_rules                      = list(string),<br>    subnet_id_for_service_rules   = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the SKU Name for this Cognitive Service Account. | `string` | `"F0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cognitive_id"></a> [cognitive\_id](#output\_cognitive\_id) | n/a |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | n/a |
| <a name="output_private_endpoint_ip_address"></a> [private\_endpoint\_ip\_address](#output\_private\_endpoint\_ip\_address) | n/a |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | n/a |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | n/a |
| <a name="output_service_endpoint"></a> [service\_endpoint](#output\_service\_endpoint) | n/a |
<!-- END_TF_DOCS -->