# AWS SNS Topic Subscription Module

## Usage

```hcl
module "sns-topics" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/sns-topic-subscription?ref=main"

  sns_topic_name = "example-topic"
  subscribing_endpoints = {
    "arn:aws:sqs:eu-west-3:444455556666:qtest" = {
      protocol              = "sqs"
      raw_message_delivery  = true
      filter_policy         = jsonencode({
        "type" = ["example"]
      })
    },
    "+00555123456" = {
      protocol = "sms"
    },
  }
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
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Name of the SNS topic to subscribe to. | `string` | n/a | yes |
| <a name="input_subscribing_endpoints"></a> [subscribing\_endpoints](#input\_subscribing\_endpoints) | A map of configuration for endpoints that will subscribe to the SNS topic. The raw\_message\_delivery option is for sqs and https only. | <pre>map(object({<br>    protocol              = string<br>    raw_message_delivery  = optional(bool)<br>    filter_policy         = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_arns"></a> [subscription\_arns](#output\_subscription\_arns) | n/a |
<!-- END_TF_DOCS -->