# AWS EventBridge Pipe Module Example

## Sample DynamoDB table entry
Use the JSON document below, or similar entry, to add to the DynamoDB table to trigger insert events with current example.

```json
{
  "pk_customer_id": {
    "S": "CID-123"
  },
  "sk_order_date": {
    "S": "2023-01-15"
  },
  "order_id": {
    "N": "1"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db-table"></a> [db-table](#module\_db-table) | ../../../aws/dynamodb | n/a |
| <a name="module_dynamodb-sns-event-pipe"></a> [dynamodb-sns-event-pipe](#module\_dynamodb-sns-event-pipe) | ../../../aws/eventbridge-pipe | n/a |
| <a name="module_sns-topic"></a> [sns-topic](#module\_sns-topic) | ../../../aws/sns | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.dynamodb-pipe-source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sns-pipe-target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.dynamodb-pipe-source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sns-pipe-target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudformation_stack_id"></a> [cloudformation\_stack\_id](#output\_cloudformation\_stack\_id) | n/a |
| <a name="output_pipe_arn"></a> [pipe\_arn](#output\_pipe\_arn) | n/a |
<!-- END_TF_DOCS -->