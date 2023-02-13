# AWS DynamoDB Module
Amazon DynamoDB is a NoSQL database that supports key-value and document data models. Developers can use DynamoDB to build modern, serverless applications that can start small and scale globally to support petabytes of data and tens of millions of read and write requests per second. DynamoDB is designed to run high-performance, internet-scale applications that would overburden traditional relational databases. For more information, see [Amazon DynamoDB](https://aws.amazon.com/dynamodb/).

## Feature highlights

* Support for On-demand and Provisioned billing modes.
* Optionally create various Local and Global Secondary Indexes for alternative key structures and efficient data access.
* Optionally enable DynamoDB Streams for event-driven applications.
* Optionally enable TTL on the TTL timestamp attribute.

## Usage

```hcl
module "db-table" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/dynamodb?ref=main"

  table_name         = "TF_Customer_Orders_Example_DEV"
  billing_mode       = "PAY_PER_REQUEST"
  partition_key      = "pk_customer_id"
  sort_key           = "sk_order_date"
  enable_stream      = true
  stream_view_type   = "NEW_IMAGE"
  ttl_attribute_name = "ttl"

  attributes = [
    {
      name = "pk_customer_id"
      type = "S"
    },
    {
      name = "sk_order_date"
      type = "S"
    },
  ]

  global_secondary_indexes = [
    {
      name               = "example_idx"
      partition_key      = "pk_customer_id"
      sort_key           = "sk_order_date"
      projection_type    = "KEYS_ONLY"
    },
  ]

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Set of nested attribute definitions. Only required for hash\_key. | <pre>list(object({<br>    name = string<br>    type = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "pk",<br>    "type": "S"<br>  }<br>]</pre> | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Controls how you are charged for read and write throughput and how you manage capacity. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_enable_stream"></a> [enable\_stream](#input\_enable\_stream) | Indicates whether or not to enable DynamoDB Streams. | `bool` | `false` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Describes up to 20 GSIs on the table. Read and write capacities are only required when billing\_mode is set to `PROVISIONED`. The `projection_type` supports one of `ALL`, `INCLUDE` or `KEYS_ONLY` where ALL projects every attribute into the index, KEYS\_ONLY projects into the index only the table and index hash\_key and sort\_key attributes, INCLUDE projects into the index all of the attributes that are defined in non\_key\_attributes in addition to the attributes that KEYS\_ONLY project. | <pre>list(object({<br>    name               = string<br>    partition_key      = string<br>    sort_key           = optional(string)<br>    projection_type    = string<br>    non_key_attributes = optional(list(string), null)<br>    read_capacity      = optional(number, null)<br>    write_capacity     = optional(number, null)<br>  }))</pre> | `[]` | no |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | Describes up to 5 LSIs on the table. The `projection_type` supports one of `ALL`, `INCLUDE` or `KEYS_ONLY` where ALL projects every attribute into the index, KEYS\_ONLY projects into the index only the table and index hash\_key and sort\_key attributes, INCLUDE projects into the index all of the attributes that are defined in non\_key\_attributes in addition to the attributes that KEYS\_ONLY project. Forces new resource. | <pre>list(object({<br>    name               = string<br>    sort_key           = string<br>    projection_type    = string<br>    non_key_attributes = optional(list(string), null)<br>  }))</pre> | `[]` | no |
| <a name="input_partition_key"></a> [partition\_key](#input\_partition\_key) | Attribute to use as the hash (partition) key. Must also be defined as an attribute. Changes force a new resource. | `string` | n/a | yes |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | Number of read units for this table. Required if the billing\_mode is set to PROVISIONED. | `number` | `5` | no |
| <a name="input_sort_key"></a> [sort\_key](#input\_sort\_key) | Attribute to use as the range (sort) key. Must also be defined as an attribute. Changes force a new resource. | `string` | `null` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | When an item in the table is modified, StreamViewType determines what information is written to the table's stream. | `string` | `"NEW_IMAGE"` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | Storage class of the table. | `string` | `"STANDARD"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of the table. Has to be unique within a region of the table. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | Name of the table attribute to store the TTL timestamp in. Setting this auto enables this feature. | `string` | `null` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | Number of write units for this table. Required if the billing\_mode is set to PROVISIONED. | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | n/a |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | n/a |
| <a name="output_dynamodb_table_stream_arn"></a> [dynamodb\_table\_stream\_arn](#output\_dynamodb\_table\_stream\_arn) | n/a |
<!-- END_TF_DOCS -->