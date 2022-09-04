# Azure AKS Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.21.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_aks"></a> [private\_aks](#module\_private\_aks) | ../../../azure/aks | n/a |
| <a name="module_public_aks"></a> [public\_aks](#module\_public\_aks) | ../../../azure/aks | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.selected](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | `"West Europe"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Specifies the name of the Subnet. Only used by private AKS for advanced networking. | `string` | n/a | yes |
| <a name="input_subnet_resource_group_name"></a> [subnet\_resource\_group\_name](#input\_subnet\_resource\_group\_name) | Specifies the name of the resource group the Virtual Network is located in. Only used by private AKS for advanced networking. | `string` | n/a | yes |
| <a name="input_subnet_vnet_name"></a> [subnet\_vnet\_name](#input\_subnet\_vnet\_name) | Specifies the name of the Virtual Network this Subnet is located within. Only used by private AKS for advanced networking. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_aks_client_certificate"></a> [private\_aks\_client\_certificate](#output\_private\_aks\_client\_certificate) | n/a |
| <a name="output_private_aks_client_key"></a> [private\_aks\_client\_key](#output\_private\_aks\_client\_key) | n/a |
| <a name="output_private_aks_cluster_ca_certificate"></a> [private\_aks\_cluster\_ca\_certificate](#output\_private\_aks\_cluster\_ca\_certificate) | n/a |
| <a name="output_private_aks_cluster_id"></a> [private\_aks\_cluster\_id](#output\_private\_aks\_cluster\_id) | n/a |
| <a name="output_private_aks_cluster_password"></a> [private\_aks\_cluster\_password](#output\_private\_aks\_cluster\_password) | n/a |
| <a name="output_private_aks_cluster_username"></a> [private\_aks\_cluster\_username](#output\_private\_aks\_cluster\_username) | n/a |
| <a name="output_private_aks_fqdn"></a> [private\_aks\_fqdn](#output\_private\_aks\_fqdn) | n/a |
| <a name="output_private_aks_host"></a> [private\_aks\_host](#output\_private\_aks\_host) | n/a |
| <a name="output_private_aks_kube_config"></a> [private\_aks\_kube\_config](#output\_private\_aks\_kube\_config) | n/a |
| <a name="output_private_aks_kubeconfig_cmd"></a> [private\_aks\_kubeconfig\_cmd](#output\_private\_aks\_kubeconfig\_cmd) | n/a |
| <a name="output_private_aks_log_analytics_workspace_id"></a> [private\_aks\_log\_analytics\_workspace\_id](#output\_private\_aks\_log\_analytics\_workspace\_id) | n/a |
| <a name="output_private_aks_oidc_issuer_url"></a> [private\_aks\_oidc\_issuer\_url](#output\_private\_aks\_oidc\_issuer\_url) | n/a |
| <a name="output_private_aks_resource_group_id"></a> [private\_aks\_resource\_group\_id](#output\_private\_aks\_resource\_group\_id) | n/a |
| <a name="output_private_aks_secondary_node_pool"></a> [private\_aks\_secondary\_node\_pool](#output\_private\_aks\_secondary\_node\_pool) | n/a |
| <a name="output_private_aks_ssh_private_key"></a> [private\_aks\_ssh\_private\_key](#output\_private\_aks\_ssh\_private\_key) | n/a |
| <a name="output_private_aks_ssh_private_key_storage_blob_id"></a> [private\_aks\_ssh\_private\_key\_storage\_blob\_id](#output\_private\_aks\_ssh\_private\_key\_storage\_blob\_id) | n/a |
| <a name="output_private_aks_ssh_private_key_storage_blob_url"></a> [private\_aks\_ssh\_private\_key\_storage\_blob\_url](#output\_private\_aks\_ssh\_private\_key\_storage\_blob\_url) | n/a |
| <a name="output_public_aks_client_certificate"></a> [public\_aks\_client\_certificate](#output\_public\_aks\_client\_certificate) | n/a |
| <a name="output_public_aks_client_key"></a> [public\_aks\_client\_key](#output\_public\_aks\_client\_key) | n/a |
| <a name="output_public_aks_cluster_ca_certificate"></a> [public\_aks\_cluster\_ca\_certificate](#output\_public\_aks\_cluster\_ca\_certificate) | n/a |
| <a name="output_public_aks_cluster_id"></a> [public\_aks\_cluster\_id](#output\_public\_aks\_cluster\_id) | n/a |
| <a name="output_public_aks_cluster_password"></a> [public\_aks\_cluster\_password](#output\_public\_aks\_cluster\_password) | n/a |
| <a name="output_public_aks_cluster_username"></a> [public\_aks\_cluster\_username](#output\_public\_aks\_cluster\_username) | n/a |
| <a name="output_public_aks_fqdn"></a> [public\_aks\_fqdn](#output\_public\_aks\_fqdn) | n/a |
| <a name="output_public_aks_host"></a> [public\_aks\_host](#output\_public\_aks\_host) | n/a |
| <a name="output_public_aks_kube_config"></a> [public\_aks\_kube\_config](#output\_public\_aks\_kube\_config) | n/a |
| <a name="output_public_aks_kubeconfig_cmd"></a> [public\_aks\_kubeconfig\_cmd](#output\_public\_aks\_kubeconfig\_cmd) | n/a |
| <a name="output_public_aks_log_analytics_workspace_id"></a> [public\_aks\_log\_analytics\_workspace\_id](#output\_public\_aks\_log\_analytics\_workspace\_id) | n/a |
| <a name="output_public_aks_oidc_issuer_url"></a> [public\_aks\_oidc\_issuer\_url](#output\_public\_aks\_oidc\_issuer\_url) | n/a |
| <a name="output_public_aks_resource_group_id"></a> [public\_aks\_resource\_group\_id](#output\_public\_aks\_resource\_group\_id) | n/a |
| <a name="output_public_aks_secondary_node_pool"></a> [public\_aks\_secondary\_node\_pool](#output\_public\_aks\_secondary\_node\_pool) | n/a |
| <a name="output_public_aks_ssh_private_key"></a> [public\_aks\_ssh\_private\_key](#output\_public\_aks\_ssh\_private\_key) | n/a |
| <a name="output_public_aks_ssh_private_key_storage_blob_id"></a> [public\_aks\_ssh\_private\_key\_storage\_blob\_id](#output\_public\_aks\_ssh\_private\_key\_storage\_blob\_id) | n/a |
| <a name="output_public_aks_ssh_private_key_storage_blob_url"></a> [public\_aks\_ssh\_private\_key\_storage\_blob\_url](#output\_public\_aks\_ssh\_private\_key\_storage\_blob\_url) | n/a |
<!-- END_TF_DOCS -->