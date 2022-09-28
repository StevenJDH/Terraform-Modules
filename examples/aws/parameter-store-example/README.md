# AWS Parameter Store Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_parameter-store-example"></a> [parameter-store-example](#module\_parameter-store-example) | ../../../aws/parameter-store | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_example_password"></a> [example\_password](#input\_example\_password) | AWS region. | `string` | `"swordfish"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameter_store_arns_and_versions"></a> [parameter\_store\_arns\_and\_versions](#output\_parameter\_store\_arns\_and\_versions) | n/a |
<!-- END_TF_DOCS -->