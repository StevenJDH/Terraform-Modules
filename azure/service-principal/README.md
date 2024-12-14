# Azure Service Principal Module
Creates a service principal and an app registration with a built-in or custom role assignment.

## Feature highlights

* Optionally creates a custom role or assigns a built-in role.
* Manages a secret that is renewed every specified days with the renewal date in the description.
* Optionally use created secret with scripts or other terraform resources without exposure.


## Usage

```hcl
module "sp-example" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/service-principal?ref=main"

  service_principal_name      = "my-sp-example-dev"
  role_definition_name        = "Contributor"
  scope                       = data.azurerm_subscription.primary.id
  client_secret_rotation_days = 730
  owners                      = [data.azurerm_client_config.current.object_id]
}

module "custom-sp-example" {
  source = "github.com/StevenJDH/Terraform-Modules//azure/service-principal?ref=main"

  service_principal_name        = "my-custom-sp-example-dev"
  role_definition_name          = "Example"
  scope                         = data.azurerm_subscription.primary.id
  client_secret_rotation_days   = 365
  owners                        = [data.azurerm_client_config.current.object_id]

  create_custom_role_definition = true
  custom_role_description       = "This is a custom example."
  custom_role_actions           = ["Microsoft.Storage/storageAccounts/read"]
  custom_role_data_actions      = ["*"]
  custom_role_assignable_scopes = [data.azurerm_subscription.primary.id]
}
```

## Optional cleanup
When deleting an Entra ID registered application, the app registration itself is not permanently deleted during a terraform destroy. To permanently delete it without having to wait the 30 days for Azure to automatically do it, go to `App registrations` in Microsoft Entra ID, and under the `Deleted applications` tab, remove the needed entries.

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
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.12 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [time_rotating.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_secret_rotation_days"></a> [client\_secret\_rotation\_days](#input\_client\_secret\_rotation\_days) | Number of days to wait until client secret is regenerated, max 730 days. Changing this forces the creation of a new secret. | `number` | `730` | no |
| <a name="input_create_custom_role_definition"></a> [create\_custom\_role\_definition](#input\_create\_custom\_role\_definition) | Indicates whether or not to create a custom role definition. | `bool` | `false` | no |
| <a name="input_custom_role_actions"></a> [custom\_role\_actions](#input\_custom\_role\_actions) | One or more allowed actions such as `*` for the custom role definition. | `list(string)` | `[]` | no |
| <a name="input_custom_role_assignable_scopes"></a> [custom\_role\_assignable\_scopes](#input\_custom\_role\_assignable\_scopes) | One or more assignable scopes for the custom role definition. | `list(string)` | `[]` | no |
| <a name="input_custom_role_data_actions"></a> [custom\_role\_data\_actions](#input\_custom\_role\_data\_actions) | One or more allowed data actions such as `*` for the custom role definition. | `set(string)` | `[]` | no |
| <a name="input_custom_role_description"></a> [custom\_role\_description](#input\_custom\_role\_description) | A description of the custom role definition. | `string` | `null` | no |
| <a name="input_custom_role_not_actions"></a> [custom\_role\_not\_actions](#input\_custom\_role\_not\_actions) | One or more disallowed actions such as `*` for the custom role definition. | `list(string)` | `[]` | no |
| <a name="input_custom_role_not_data_actions"></a> [custom\_role\_not\_data\_actions](#input\_custom\_role\_not\_data\_actions) | One or more disallowed data actions such as `*` for the custom role definition. | `set(string)` | `[]` | no |
| <a name="input_owners"></a> [owners](#input\_owners) | A set of object IDs of principals that will be granted ownership of the application/service principal. | `set(string)` | n/a | yes |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | The name of the custom role definition or built-in role if `create_custom_role_definition` is set to `false`. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope at which the role will be applied. | `string` | n/a | yes |
| <a name="input_service_principal_name"></a> [service\_principal\_name](#input\_service\_principal\_name) | Name of service principal. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | n/a |
| <a name="output_client_secret"></a> [client\_secret](#output\_client\_secret) | Use `terraform output -raw <output-name>` to read value. |
<!-- END_TF_DOCS -->