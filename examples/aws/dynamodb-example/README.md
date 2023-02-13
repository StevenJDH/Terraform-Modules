# AWS DynamoDB Module Example

## Sample DynamoDB table entry
Use the JSON document below, or similar entry, to add to the DynamoDB table for current example.

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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db-table"></a> [db-table](#module\_db-table) | ../../../aws/dynamodb | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | n/a |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | n/a |
| <a name="output_dynamodb_table_stream_arn"></a> [dynamodb\_table\_stream\_arn](#output\_dynamodb\_table\_stream\_arn) | n/a |
<!-- END_TF_DOCS -->