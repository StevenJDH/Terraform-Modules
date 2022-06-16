# AWS Parameter Store Module

## Usage

```hcl
module "parameter-store-example" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/parameter-store?ref=main"

  configuration = {
    "/config/marco_dev/example.endpoint" = {
      value = "polo"
    },
    "/config/foobar_dev/example.password" = {
      value  = var.example_password
      secure = true
    },
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration"></a> [configuration](#input\_configuration) | A map of configuration. Valid tiers are Standard, Advanced, and Intelligent-Tiering, but if not specified, default for region is used. | <pre>map(object({<br>    description = optional(string)<br>    value       = string<br>    tier        = optional(string)<br>    secure      = optional(bool)<br>  }))</pre> | n/a | yes |
| <a name="input_secret"></a> [secret](#input\_secret) | Indicates whether or not to define configuration as a secret. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameter_store_arns_and_versions"></a> [parameter\_store\_arns\_and\_versions](#output\_parameter\_store\_arns\_and\_versions) | n/a |
<!-- END_TF_DOCS -->