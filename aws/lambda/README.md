# AWS Lambda Module

## Feature highlights

* Creates simple lambdas, VPC associated lambdas, and stateful lambdas with mounted EFS storage.  
* Manages the creation of IAM Roles for each supported scenario, and attaching additional policies.
* Creates lambdas from deployment packages preloaded in a centralized S3 bucket.
* Optionally creates any needed event triggers for lambdas, like with SQS.
* Optionally supports S3 versioning IDs to rollout or rollback to a different package variant.
* Optionally supports triggering a lambda with a custom playload after creation, and outputting its response.
* Optionally manages multiple lambdas definitions in one module.

## Usage

```hcl
module "simple-lambda" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/lambda?ref=main"

  s3_bucket_name   = "tf-lambda-packages"
  region           = "eu-west-3"
  lambda_functions = [
    {
      function_name            = "hello-world-example-dev"
      description              = "This is an example lambda."
      runtime                  = "java11"
      handler                  = "com.example.App::handleRequest"
      timeout_in_seconds       = 30
      cw_log_retention_in_days = 7
      deployment_package_key   = "dev/hello-world-example-0.1.0-aws.zip"
    },
  ]

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

module "vpc-lambda" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/lambda?ref=main"

  s3_bucket_name   = "tf-lambda-packages"
  region           = "eu-west-3"
  lambda_functions = [
    {
      function_name            = "hello-world-example2-dev"
      description              = "This is an example lambda."
      runtime                  = "java11"
      handler                  = "com.example.App::handleRequest"
      timeout_in_seconds       = 30
      cw_log_retention_in_days = 7
      deployment_package_key   = "dev/hello-world-example-0.1.0-aws.zip"
      vpc_subnet_ids           = ["subnet-1234abcd",]
      vpc_security_group_ids   = ["sg-123456abcdef",]
    },
  ]

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}

module "efs-lambda" {
  source = "github.com/StevenJDH/Terraform-Modules//aws/lambda?ref=main"

  s3_bucket_name   = "tf-lambda-packages"
  region           = "eu-west-3"
  lambda_functions = [
    {
      function_name            = "hello-world-example3-dev"
      description              = "This is an example lambda."
      runtime                  = "java11"
      handler                  = "com.example.App::handleRequest"
      timeout_in_seconds       = 30
      cw_log_retention_in_days = 7
      deployment_package_key   = "dev/hello-world-example-0.1.0-aws.zip"
      enable_efs_support       = true
      efs_access_point_arn     = data.aws_efs_access_point.selected.arn
      efs_local_mount_path     = "test" # Do not include '/mnt/' prefix.
      efs_file_system_id       = data.aws_efs_access_point.selected.file_system_id
      efs_enable_read_write    = true
      vpc_subnet_ids           = ["subnet-1234abcd",]
      vpc_security_group_ids   = ["sg-123456abcdef",]
    },
  ]

  tags = {
    # Similar to provider tag propagation, but module scoped.
    type = "example"
  }
}
```

## Function deployment package
To create a deployment package for a function, zip the file or files needed for deployment. Next, run the following commands to create a file containing the base64 encoded SHA256 hash of the archive:

**Bash** (Windows users can use git bash)
```bash
package=app-0.1.0-aws.zip
openssl dgst -sha256 -binary $package | openssl enc -base64 > $package.base64sha256.txt
```

**Windows Command Prompt**

```batch
set package=app-0.1.0-aws.zip
openssl dgst -sha256 -binary %package% | openssl enc -base64 > %package%.base64sha256.txt
```

Finally, upload the archive and the hash file to a centralized S3 bucket to make it ready for deployment. If versioning is enabled, setting `s3_zip_object_version` and `s3_hash_object_version` with the versioning IDs for the file pairs will enable rollbacks as needed.

## EFS storage
Requires VPC access and `enable_efs_support` set to `true`. Allows for the creation of stateful lambdas by creating a local mount path inside the lambda function to an EFS mount target. The local mount path must start with `/mnt/`, but this is automatically added, so do not include this prefix. Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted. Make sure to set a `custom tcp` inbound rule in a security group for port 2049 that is associated to the lambda and the EFS instance. When creating or updating Lambda functions, mount targets must be in `Available` lifecycle state.

To test the EFS integration, include the following settings for the lambda using the efs-lambda module above as a starting point, and prepare a deployment package using the `test.py` file.

```hcl
runtime = "python3.9"
handler = "test.lambda_handler"
```

**test.py**

```python
import json
import os

def lambda_handler(event, context):
    print("Before: ", os.listdir("/mnt/test"))

    with open("/mnt/test/randomfile.txt", "w") as file:
        file.write("hello world")

    print("After: ", os.listdir("/mnt/test"))

    return {"statusCode": 200, "body": json.dumps("Hello from Lambda!")}
```

If all goes well, the lambda logs should show something similar to the below where a new file was created and can now be seen by each execution or other lambdas also mounted to the same EFS mount target.

```bash
Function Logs
START RequestId: 00000000-0000-0000-0000-000000000000 Version: $LATEST
Before:  []
After:  ['randomfile.txt']
END RequestId: 00000000-0000-0000-0000-000000000000
```

**Note:** Due to AWS Lambda improved VPC networking changes that began deploying in September 2019, EC2 subnets and security groups associated with Lambda Functions can take up to 45 minutes to successfully delete. Terraform AWS Provider version 2.31.0 and later automatically handles this increased timeout. AWS and HashiCorp are working together to reduce the amount of time required for resource deletion and updates can be tracked in this [GitHub issue](https://github.com/hashicorp/terraform-provider-aws/issues/10329).

## Invoking lambdas
For scenarios where something like this could be interesting, this module supports triggering a Lambda Function after it's creation with a provided payload. This action is only triggered during the creation or update of the lambda.

To test the lambda invocation feature, include the following settings for the lambda using the simple-lambda module above as a starting point, and prepare a deployment package using the `test.js` file.

```hcl
runtime             = "nodejs16.x"
handler             = "test.handler"
invoke_with_payload = "{\"test\":\"hello world!\"}"
```

**test.js**

```node
exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: event.test,
    };
    return response;
};
```

If all goes well, the response will be available in the outputs of Terraform, and already json decoded for use in Terraform code.

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.32.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.cloud-watch-log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cloud-watch-log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.efs-client-read-only-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.efs-client-read-write-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda-vpc-access-execution-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_s3_object.lambda-package-hash](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_object) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lambda_functions"></a> [lambda\_functions](#input\_lambda\_functions) | Sets the Lambda configuration, which manages basic config, VPC access, EFS mount points, event triggers, and role config. The function deployment packages must be available in a centralized S3 bucket along with their hash file to detect changes. If `deployment_package_key` isn't specified, then it's assumed that the deployment package key matches the function name with `.zip` at the end. The deployment package key can also include folder names in the S3 bucket. See [Runtimes](https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime) for valid values when selecting the programming language. | <pre>list(object({<br>    function_name            = string<br>    description              = optional(string)<br>    runtime                  = string<br>    handler                  = string<br>    timeout_in_seconds       = optional(number, 3)<br>    ephemeral_storage_size   = optional(number, 512)<br>    environment_variables    = optional(map(string), {})<br>    enable_event_source      = optional(bool, false)<br>    event_source_arn         = optional(string)<br>    event_source_batch_size  = optional(number, 1)<br>    deployment_package_key   = optional(string)<br>    s3_zip_object_version    = optional(string)<br>    s3_hash_object_version   = optional(string)<br>    memory_size_in_mb        = optional(number, 128)<br>    reserved_concurrency     = optional(number, -1)<br>    cw_log_retention_in_days = optional(number, 90)<br>    enable_efs_support       = optional(bool, false)<br>    efs_access_point_arn     = optional(string, null)<br>    efs_local_mount_path     = optional(string, null)<br>    efs_file_system_id       = optional(string, null)<br>    efs_enable_read_write    = optional(bool, false)<br>    vpc_subnet_ids           = optional(list(string), [])<br>    vpc_security_group_ids   = optional(list(string), [])<br>    invoke_with_payload      = optional(string)<br>    additional_policy_arns   = optional(list(string), [])<br>  }))</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket location containing the function deployment packages. This bucket must reside in the same AWS region where the Lambda functions are being created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_info"></a> [cloudwatch\_log\_group\_info](#output\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_function_details"></a> [function\_details](#output\_function\_details) | n/a |
| <a name="output_invoked_lambda_response"></a> [invoked\_lambda\_response](#output\_invoked\_lambda\_response) | n/a |
<!-- END_TF_DOCS -->