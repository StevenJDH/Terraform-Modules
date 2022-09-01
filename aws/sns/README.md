# AWS SNS Module

## Usage

```hcl
module "sns-topics" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/sns?ref=main"

  topic_names   = ["tf-sns-example-dev"]
}

module "sns-fifo-topics" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/sns?ref=main"

  topic_names   = ["tf-sns-example2-dev"]
  fifo_topic    = true
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
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
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backoff_function"></a> [backoff\_function](#input\_backoff\_function) | The model for backoff between retries. One of four options: arithmetic, exponential, geometric, or linear. | `string` | `"linear"` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | (Optional) Enables content-based deduplication for FIFO topics. | `bool` | `false` | no |
| <a name="input_fifo_topic"></a> [fifo\_topic](#input\_fifo\_topic) | (Optional) Indicates whether or not to create a FIFO (first-in-first-out) topic. Default is false. | `bool` | `false` | no |
| <a name="input_max_delay_target_seconds"></a> [max\_delay\_target\_seconds](#input\_max\_delay\_target\_seconds) | The maximum delay for a retry. Minimum delay to 3,600. | `number` | `20` | no |
| <a name="input_max_receives_per_second"></a> [max\_receives\_per\_second](#input\_max\_receives\_per\_second) | The maximum number of deliveries per second, per subscription. 1 or greater. Default: No throttling (null). | `number` | `null` | no |
| <a name="input_min_delay_target_seconds"></a> [min\_delay\_target\_seconds](#input\_min\_delay\_target\_seconds) | The minimum delay for a retry. 1 to maximum delay. | `number` | `20` | no |
| <a name="input_num_max_delay_retries"></a> [num\_max\_delay\_retries](#input\_num\_max\_delay\_retries) | The number of retries in the post-backoff phase, with the maximum delay between them. 0 or greater. | `number` | `0` | no |
| <a name="input_num_min_delay_retries"></a> [num\_min\_delay\_retries](#input\_num\_min\_delay\_retries) | The number of retries in the pre-backoff phase, with the specified minimum delay between them. 0 or greater. | `number` | `0` | no |
| <a name="input_num_no_delay_retries"></a> [num\_no\_delay\_retries](#input\_num\_no\_delay\_retries) | The number of retries to be done immediately, with no delay between them. 0 or greater. | `number` | `0` | no |
| <a name="input_num_retries"></a> [num\_retries](#input\_num\_retries) | The total number of retries, including immediate, pre-backoff, backoff, and post-backoff retries. 0 to 100. | `number` | `3` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_topic_names"></a> [topic\_names](#input\_topic\_names) | List of topic names. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | n/a |
<!-- END_TF_DOCS -->