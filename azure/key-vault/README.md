# Azure Key Vault Module

## Usage

```hcl
module "public-key-vault" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/key-vault?ref=main"

  key_vault_name        = "kv-example-${random_string.this.id}-${local.stage}"
  create_resource_group = true
  resource_group_name   = "rg-key-vault-example-${local.stage}"
  access_policies       = {
    (data.azurerm_client_config.current.object_id) = {
      certificate_permissions = ["List", "Get"]
      key_permissions         = ["List", "Get"]
      secret_permissions      = ["List", "Get", "Delete", "Recover", "Set", "Purge", "Restore"]
      storage_permissions     = ["List", "Get"]
    },
  }
  location              = "West Europe"
}

module "private-key-vault" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/key-vault?ref=main"

  key_vault_name        = "kv-example2-${random_string.this.id}-${local.stage}"
  create_resource_group = true
  resource_group_name   = "rg-key-vault-example2-${local.stage}"
  access_policies       = {
    (data.azurerm_client_config.current.object_id) = {
      certificate_permissions = ["List", "Get"]
      key_permissions         = ["List", "Get"]
      secret_permissions      = ["List", "Get", "Delete", "Recover", "Set", "Purge", "Restore"]
      storage_permissions     = ["List", "Get"]
    },
  }
  location              = "West Europe"

  network_acls                      = {
    bypass_network_acls           = true
    allow_when_no_acl_rules_match = false
    ip_rules                      = []
    virtual_network_subnet_ids    = []
  }
  create_private_endpoint           = true
  subnet_endpoint_id                = data.azurerm_subnet.example.id
  create_private_dns_resource_group = true
  private_dns_resource_group_name   = "rg-example2-${local.stage}"
  create_private_dns_zone           = true
  create_private_dns_record         = true
  create_private_dns_zone_vnet_link = true
  virtual_network_id                = data.azurerm_virtual_network.example.id
}
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_privatelink-dns-record"></a> [privatelink-dns-record](#module\_privatelink-dns-record) | ../dns-a-record | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | A map of up to 16 objects describing access policies. | <pre>map(object({<br>    certificate_permissions = list(string)<br>    key_permissions         = list(string)<br>    secret_permissions      = list(string)<br>    storage_permissions     = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_create_private_dns_record"></a> [create\_private\_dns\_record](#input\_create\_private\_dns\_record) | Indicates whether or not to create a private dns record for the private endpoint. | `bool` | `false` | no |
| <a name="input_create_private_dns_resource_group"></a> [create\_private\_dns\_resource\_group](#input\_create\_private\_dns\_resource\_group) | Indicates whether or not to create a private dns resource group. | `bool` | `true` | no |
| <a name="input_create_private_dns_zone"></a> [create\_private\_dns\_zone](#input\_create\_private\_dns\_zone) | Indicates whether or not to create a DNS zone. | `bool` | `false` | no |
| <a name="input_create_private_dns_zone_vnet_link"></a> [create\_private\_dns\_zone\_vnet\_link](#input\_create\_private\_dns\_zone\_vnet\_link) | Indicates whether or not to create a private DNS zone virtual network link. | `bool` | `false` | no |
| <a name="input_create_private_endpoint"></a> [create\_private\_endpoint](#input\_create\_private\_endpoint) | Indicates whether or not to create a private endpoint. | `bool` | `false` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Indicates whether or not to create a resource group. | `bool` | `true` | no |
| <a name="input_enable_auto_registration"></a> [enable\_auto\_registration](#input\_enable\_auto\_registration) | Indicates whether or not to enable auto-registration of virtual machine records in the virtual network in the Private DNS zone. | `bool` | `true` | no |
| <a name="input_enable_purge_protection"></a> [enable\_purge\_protection](#input\_enable\_purge\_protection) | Indicates whether or not to enable purge protection. Once Purge Protection has been Enabled it's not possible to Disable it. If Key Vault is deleted, Azure will purge the instance in 90 days. | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of Key Vault. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Specifies whether Azure service traffic can bypass the network rules, default action to use when no rules match from ip\_rules / virtual\_network\_subnet\_ids, and One or more Subnet IDs which should be able to access this Key Vault. | <pre>object({<br>    bypass_network_acls           = bool,<br>    allow_when_no_acl_rules_match = bool,<br>    ip_rules                      = list(string),<br>    virtual_network_subnet_ids    = list(string)<br>  })</pre> | `null` | no |
| <a name="input_private_dns_resource_group_name"></a> [private\_dns\_resource\_group\_name](#input\_private\_dns\_resource\_group\_name) | Name of DNS resource group. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The Name of the SKU used for this Key Vault. Possible values are standard and premium. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. | `number` | `90` | no |
| <a name="input_subnet_endpoint_id"></a> [subnet\_endpoint\_id](#input\_subnet\_endpoint\_id) | The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL for private DNS A record. | `number` | `3600` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | Virtual network Id for private DNS zone virtual network link. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | n/a |
| <a name="output_private_endpoint_ip_address"></a> [private\_endpoint\_ip\_address](#output\_private\_endpoint\_ip\_address) | n/a |
| <a name="output_privatelink_dns_a_record_id"></a> [privatelink\_dns\_a\_record\_id](#output\_privatelink\_dns\_a\_record\_id) | n/a |
| <a name="output_privatelink_dns_zone_id"></a> [privatelink\_dns\_zone\_id](#output\_privatelink\_dns\_zone\_id) | n/a |
| <a name="output_privatelink_resource_group_id"></a> [privatelink\_resource\_group\_id](#output\_privatelink\_resource\_group\_id) | n/a |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | n/a |
<!-- END_TF_DOCS -->