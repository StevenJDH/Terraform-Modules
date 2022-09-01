# AWS SQS Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sqs-fifo-queues-with-dlq"></a> [sqs-fifo-queues-with-dlq](#module\_sqs-fifo-queues-with-dlq) | ../../../aws/sqs | n/a |
| <a name="module_sqs-queues"></a> [sqs-queues](#module\_sqs-queues) | ../../../aws/sqs | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_arns"></a> [sqs\_arns](#output\_sqs\_arns) | n/a |
| <a name="output_sqs_fifo_arns"></a> [sqs\_fifo\_arns](#output\_sqs\_fifo\_arns) | n/a |
| <a name="output_sqs_fifo_dlq_arns"></a> [sqs\_fifo\_dlq\_arns](#output\_sqs\_fifo\_dlq\_arns) | n/a |
<!-- END_TF_DOCS -->