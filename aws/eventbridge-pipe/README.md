# AWS EventBridge Pipe Module
Amazon EventBridge Pipes connects sources to targets. It reduces the need for specialized knowledge and integration code when developing event driven architectures, fostering consistency across your company’s applications. In addition, EventBridge Pipes help to lower compute and usage costs by using event filters and built-in integrations to only process and pay for events that are needed. For more information, see [Amazon EventBridge Pipes](https://aws.amazon.com/eventbridge/pipes/).

> 📝**NOTE:** Current module uses CloudFormation to create EventBridge Pipes until the AWS provider officially supports this new feature. See [hashicorp/terraform-provider-aws#28153](https://github.com/hashicorp/terraform-provider-aws/issues/28153) to track the progress for when this feature is natively implemented.

## Feature highlights

* Bridge over 14 different services together without custom code when building event-driven applications.
* Optionally define filtering and ETL processes.
* Retrieve events from sources and deliver to targets in batches to make integrations even more efficient.

## Usage

```hcl
module "dynamodb-sns-event-pipe" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/eventbridge-pipe?ref=main"

  name                      = "tf-pipe-example-dev"
  description               = "DynamoDB Event Stream to SNS."
  eventbridge_pipe_role_arn = "arn:aws:iam::000000000000:role/eventbridge-pipe-role-tf-pipe-example-dev"
  event_source_arn          = module.db-table.dynamodb_table_stream_arn
  event_target_arn          = module.sns-topic.sns_topic_arns[0]
  
  event_source_parameters = {
    DynamoDBStreamParameters = {
      BatchSize        = 1
      StartingPosition = "LATEST"
    }
    FilterCriteria = {
      Filters = [
        {
          Pattern = jsonencode({eventName=[{prefix="INSERT"}]})
        },
      ]
    }
  }
  
  event_target_parameters = {
    InputTemplate = <<-EOF
    {
      "pipeName" : <aws.pipes.pipe-name>,
      "eventName": "<$.eventName>",
      "ingestionTime": <aws.pipes.event.ingestion-time>,
      "eventSource": <$.eventSource>,
      "awsRegion": <$.awsRegion>,
      "customerId": <$.dynamodb.NewImage.pk_customer_id.S>,
      "orderDate": <$.dynamodb.NewImage.sk_order_date.S>,
      "orderId": <$.dynamodb.NewImage.order_id.S>
    }
    EOF
  }

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

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

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

module "sns-topic" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/sns?ref=main"

  topic_names = ["tf-pipe-example-topic-dev"]
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
| [aws_cloudformation_stack.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Pipe description detailing its purpose. | `string` | `null` | no |
| <a name="input_event_source_arn"></a> [event\_source\_arn](#input\_event\_source\_arn) | ARN of the source resource. Changes force a new resource. | `string` | n/a | yes |
| <a name="input_event_source_parameters"></a> [event\_source\_parameters](#input\_event\_source\_parameters) | Parameters required to set up the pipe source. | `any` | `{}` | no |
| <a name="input_event_target_arn"></a> [event\_target\_arn](#input\_event\_target\_arn) | ARN of the target resource. | `string` | n/a | yes |
| <a name="input_event_target_parameters"></a> [event\_target\_parameters](#input\_event\_target\_parameters) | Parameters required to set up the pipe target. | `any` | `{}` | no |
| <a name="input_eventbridge_pipe_role_arn"></a> [eventbridge\_pipe\_role\_arn](#input\_eventbridge\_pipe\_role\_arn) | ARN of the role that allows the pipe to retrieve and send data to the target. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the EventBridge Pipe. Changes force a new resource. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudformation_stack_id"></a> [cloudformation\_stack\_id](#output\_cloudformation\_stack\_id) | n/a |
| <a name="output_pipe_arn"></a> [pipe\_arn](#output\_pipe\_arn) | n/a |
<!-- END_TF_DOCS -->