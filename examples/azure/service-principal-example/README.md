# Azure Service Principal Module Example

Use one of the following commands below before triggering a plan or apply:

**Unix-based**

```bash
export ARM_SUBSCRIPTION_ID=$(az account list --query "[?isDefault].id" -o tsv)
```

**Window (PowerShell)**

```ps
setx ARM_SUBSCRIPTION_ID $(az account list --query "[?isDefault].id" -o tsv)
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_custom-sp-example"></a> [custom-sp-example](#module\_custom-sp-example) | ../../../azure/service-principal | n/a |
| <a name="module_sp-example"></a> [sp-example](#module\_sp-example) | ../../../azure/service-principal | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description                                              |
|------|----------------------------------------------------------|
| <a name="output_custom_sp_example_client_id"></a> [custom\_sp\_example\_client\_id](#output\_custom\_sp\_example\_client\_id) | n/a                                                      |
| <a name="output_custom_sp_example_client_secret"></a> [custom\_sp\_example\_client\_secret](#output\_custom\_sp\_example\_client\_secret) | Use `terraform output -raw <output-name>` to read value. |
| <a name="output_sp_example_client_id"></a> [sp\_example\_client\_id](#output\_sp\_example\_client\_id) | n/a                                                      |
| <a name="output_sp_example_client_secret"></a> [sp\_example\_client\_secret](#output\_sp\_example\_client\_secret) | Use `terraform output -raw <output-name>` to read value. |
<!-- END_TF_DOCS -->