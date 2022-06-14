# AWS SQS Module

## Usage

```hcl
module "sqs-queues" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/sqs"

  queue_names   = ["tf-sqs-example-dev"]
  region        = "eu-west-3"
}

module "sqs-fifo-queues-with-dlq" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/sqs"

  queue_names   = ["tf-sqs-example2-dev"]
  fifo_queue    = true
  create_dlq    = true
  region        = "eu-west-3"
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
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | (Optional) Enables content-based deduplication for FIFO queues. | `bool` | `false` | no |
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | (Optional) Indicates whether or not to create a DLQ. Default is false. | `bool` | `false` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | Specifies whether message deduplication occurs at the message group or queue level. Valid values are 'messageGroup' and 'queue' (default). | `string` | `"queue"` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). The default for this attribute is 0 seconds. | `number` | `0` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | (Optional) Indicates whether or not to create a FIFO (first-in-first-out) queue. Default is false. | `bool` | `false` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | The total number of retries. The default is 3. | `number` | `3` | no |
| <a name="input_message_retention_dlq_seconds"></a> [message\_retention\_dlq\_seconds](#input\_message\_retention\_dlq\_seconds) | The number of seconds Amazon SQS retains a DLQ message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days). | `number` | `345600` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days). | `number` | `345600` | no |
| <a name="input_queue_names"></a> [queue\_names](#input\_queue\_names) | List of queue names. | `list(string)` | n/a | yes |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). The default for this attribute is 0, meaning that the call will return immediately. | `number` | `0` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_visibility_timeout_dlq_seconds"></a> [visibility\_timeout\_dlq\_seconds](#input\_visibility\_timeout\_dlq\_seconds) | The visibility timeout for the DLQ queue. An integer from 0 to 43200 (12 hours). The default for this attribute is 30. | `number` | `30` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). The default for this attribute is 30. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_dlq_queue_arn"></a> [sqs\_dlq\_queue\_arn](#output\_sqs\_dlq\_queue\_arn) | n/a |
| <a name="output_sqs_queue_arn"></a> [sqs\_queue\_arn](#output\_sqs\_queue\_arn) | n/a |
<!-- END_TF_DOCS -->