# AWS REST API Module Example

## Note for lambda examples
The Lambda Proxy and Integration API examples require the creation of a Node.js application for their backend. Create a new Node.js-based lambda called `lambda-api-backend-dev`, and replace any starter code with the following:

```node
exports.handler = function(event, context, callback) {
    console.log('Received event:', JSON.stringify(event, null, 2));
    var res ={
        "statusCode": 200,
        "headers": {
            "Content-Type": "*/*"
        }
    };
    
    var name = 'World';
    if (event.queryStringParameters && event.queryStringParameters.person && event.queryStringParameters.person !== "") {
        name = event.queryStringParameters.person;
    } else if (event.person && event.person !== "") {
        name = event.person;
    }
    
    res.body = "Hello, " + name + "!";
    callback(null, res);
};
```

After the backend lambda is created, deploy one or both of the lambda examples. Adapt the following command to reflect the needed values, and call the API endpoints to generate a greeting.

```bash
curl -X GET https://<rest_api_id>.execute-api.<region>.amazonaws.com/dev/v1/greet?person=Steven \
    -H "Content-Type: application/json" \
    -H "Accept: application/json"
```

Removing the `?person=Steven` parameter will make the endpoint return a generic hello world greeting.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.34.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_custom-domain-rest-api"></a> [custom-domain-rest-api](#module\_custom-domain-rest-api) | ../../../aws/rest-api | n/a |
| <a name="module_lambda-integration-rest-api"></a> [lambda-integration-rest-api](#module\_lambda-integration-rest-api) | ../../../aws/rest-api | n/a |
| <a name="module_lambda-proxy-rest-api"></a> [lambda-proxy-rest-api](#module\_lambda-proxy-rest-api) | ../../../aws/rest-api | n/a |
| <a name="module_private-rest-api"></a> [private-rest-api](#module\_private-rest-api) | ../../../aws/rest-api | n/a |
| <a name="module_public-rest-api"></a> [public-rest-api](#module\_public-rest-api) | ../../../aws/rest-api | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.public-zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_vpc_endpoint.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of a VPC containing a VPC Endpoint for API Gateway. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_domain_cloudwatch_log_group_info"></a> [custom\_domain\_cloudwatch\_log\_group\_info](#output\_custom\_domain\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_custom_domain_curl_custom_domain_url"></a> [custom\_domain\_curl\_custom\_domain\_url](#output\_custom\_domain\_curl\_custom\_domain\_url) | n/a |
| <a name="output_custom_domain_curl_stage_invoke_url"></a> [custom\_domain\_curl\_stage\_invoke\_url](#output\_custom\_domain\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_custom_domain_execution_arn_for_lambda"></a> [custom\_domain\_execution\_arn\_for\_lambda](#output\_custom\_domain\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_custom_domain_rest_api_arn"></a> [custom\_domain\_rest\_api\_arn](#output\_custom\_domain\_rest\_api\_arn) | n/a |
| <a name="output_custom_domain_rest_api_id"></a> [custom\_domain\_rest\_api\_id](#output\_custom\_domain\_rest\_api\_id) | n/a |
| <a name="output_lambda_integration_cloudwatch_log_group_info"></a> [lambda\_integration\_cloudwatch\_log\_group\_info](#output\_lambda\_integration\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_lambda_integration_curl_custom_domain_url"></a> [lambda\_integration\_curl\_custom\_domain\_url](#output\_lambda\_integration\_curl\_custom\_domain\_url) | n/a |
| <a name="output_lambda_integration_curl_stage_invoke_url"></a> [lambda\_integration\_curl\_stage\_invoke\_url](#output\_lambda\_integration\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_lambda_integration_execution_arn_for_lambda"></a> [lambda\_integration\_execution\_arn\_for\_lambda](#output\_lambda\_integration\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_lambda_integration_rest_api_arn"></a> [lambda\_integration\_rest\_api\_arn](#output\_lambda\_integration\_rest\_api\_arn) | n/a |
| <a name="output_lambda_integration_rest_api_id"></a> [lambda\_integration\_rest\_api\_id](#output\_lambda\_integration\_rest\_api\_id) | n/a |
| <a name="output_lambda_proxy_cloudwatch_log_group_info"></a> [lambda\_proxy\_cloudwatch\_log\_group\_info](#output\_lambda\_proxy\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_lambda_proxy_curl_custom_domain_url"></a> [lambda\_proxy\_curl\_custom\_domain\_url](#output\_lambda\_proxy\_curl\_custom\_domain\_url) | n/a |
| <a name="output_lambda_proxy_curl_stage_invoke_url"></a> [lambda\_proxy\_curl\_stage\_invoke\_url](#output\_lambda\_proxy\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_lambda_proxy_execution_arn_for_lambda"></a> [lambda\_proxy\_execution\_arn\_for\_lambda](#output\_lambda\_proxy\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_lambda_proxy_rest_api_arn"></a> [lambda\_proxy\_rest\_api\_arn](#output\_lambda\_proxy\_rest\_api\_arn) | n/a |
| <a name="output_lambda_proxy_rest_api_id"></a> [lambda\_proxy\_rest\_api\_id](#output\_lambda\_proxy\_rest\_api\_id) | n/a |
| <a name="output_private_cloudwatch_log_group_info"></a> [private\_cloudwatch\_log\_group\_info](#output\_private\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_private_curl_custom_domain_url"></a> [private\_curl\_custom\_domain\_url](#output\_private\_curl\_custom\_domain\_url) | n/a |
| <a name="output_private_curl_stage_invoke_url"></a> [private\_curl\_stage\_invoke\_url](#output\_private\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_private_execution_arn_for_lambda"></a> [private\_execution\_arn\_for\_lambda](#output\_private\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_private_rest_api_arn"></a> [private\_rest\_api\_arn](#output\_private\_rest\_api\_arn) | n/a |
| <a name="output_private_rest_api_id"></a> [private\_rest\_api\_id](#output\_private\_rest\_api\_id) | n/a |
| <a name="output_public_cloudwatch_log_group_info"></a> [public\_cloudwatch\_log\_group\_info](#output\_public\_cloudwatch\_log\_group\_info) | n/a |
| <a name="output_public_curl_custom_domain_url"></a> [public\_curl\_custom\_domain\_url](#output\_public\_curl\_custom\_domain\_url) | n/a |
| <a name="output_public_curl_stage_invoke_url"></a> [public\_curl\_stage\_invoke\_url](#output\_public\_curl\_stage\_invoke\_url) | n/a |
| <a name="output_public_execution_arn_for_lambda"></a> [public\_execution\_arn\_for\_lambda](#output\_public\_execution\_arn\_for\_lambda) | n/a |
| <a name="output_public_rest_api_arn"></a> [public\_rest\_api\_arn](#output\_public\_rest\_api\_arn) | n/a |
| <a name="output_public_rest_api_id"></a> [public\_rest\_api\_id](#output\_public\_rest\_api\_id) | n/a |
<!-- END_TF_DOCS -->