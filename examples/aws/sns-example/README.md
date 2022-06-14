# AWS SNS Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sns-fifo-topics"></a> [sns-fifo-topics](#module\_sns-fifo-topics) | ../../../aws/sns | n/a |
| <a name="module_sns-topics"></a> [sns-topics](#module\_sns-topics) | ../../../aws/sns | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Deployment stage. | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_arns"></a> [sns\_arns](#output\_sns\_arns) | n/a |
| <a name="output_sns_fifo_arns"></a> [sns\_fifo\_arns](#output\_sns\_fifo\_arns) | n/a |
<!-- END_TF_DOCS -->