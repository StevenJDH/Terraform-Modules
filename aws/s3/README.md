# AWS S3 Module

## Usage

```hcl
module "s3-bucket" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/s3?ref=main"

  bucket_name       = "tf-example-bucket-dev"
  add_random_suffix = true
  enable_versioning = true
  lifecycle_rules = [
    {
      rule_name               = "Housekeeping"
      enable_rule             = true
      version_expiration_days = 7
      delete_incomplete_mp_upload_days = 1
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
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.aes256](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_random_suffix"></a> [add\_random\_suffix](#input\_add\_random\_suffix) | Indicates whether or not to add a random suffix to the bucket name to increase its chances of being unique. | `bool` | `false` | no |
| <a name="input_additional_resource_policy_statements"></a> [additional\_resource\_policy\_statements](#input\_additional\_resource\_policy\_statements) | Attach additional resource-based policy statements to the S3 bucket. | `list(any)` | `[]` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Indicates whether or not if S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Indicates whether or not if S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket. | `string` | n/a | yes |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Indicates whether or not to enable versioning on the bucket. Once enabled, disabling it will only suspend versioning on the bucket. AWS recommends waiting 15 minutes after initially enabling versioning before issuing write operations. | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Indicates whether or not if S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Sets the lifecycle rules that define actions that S3 applies to a group of objects such as transition and or expiration actions. | <pre>list(object({<br>    rule_name               = string<br>    enable_rule             = bool<br>    filter                  = optional(string)<br>    expiration_days         = optional(number, 0)<br>    transition              = optional(list(object({<br>      days          = number<br>      storage_class = string<br>    })), [])<br>    version_expiration_days = optional(number, 0)<br>    version_transition      = optional(list(object({<br>      noncurrent_days = number<br>      storage_class   = string<br>    })), [])<br>    delete_incomplete_mp_upload_days = optional(number, 0)<br>  }))</pre> | <pre>[<br>  {<br>    "delete_incomplete_mp_upload_days": 1,<br>    "enable_rule": true,<br>    "expiration_days": 0,<br>    "filter": null,<br>    "rule_name": "Housekeeping",<br>    "transition": [],<br>    "version_expiration_days": 30,<br>    "version_transition": []<br>  }<br>]</pre> | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Indicates whether or not if S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->