# AWS EKS Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_custom-eks"></a> [custom-eks](#module\_custom-eks) | ../../../aws/eks | n/a |
| <a name="module_simple-eks"></a> [simple-eks](#module\_simple-eks) | ../../../aws/eks | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_eks_addon_info"></a> [custom\_eks\_addon\_info](#output\_custom\_eks\_addon\_info) | n/a |
| <a name="output_custom_eks_api_server_endpoint"></a> [custom\_eks\_api\_server\_endpoint](#output\_custom\_eks\_api\_server\_endpoint) | n/a |
| <a name="output_custom_eks_cloudwatch_log_group_arn"></a> [custom\_eks\_cloudwatch\_log\_group\_arn](#output\_custom\_eks\_cloudwatch\_log\_group\_arn) | n/a |
| <a name="output_custom_eks_cloudwatch_log_group_id"></a> [custom\_eks\_cloudwatch\_log\_group\_id](#output\_custom\_eks\_cloudwatch\_log\_group\_id) | n/a |
| <a name="output_custom_eks_cloudwatch_log_group_name"></a> [custom\_eks\_cloudwatch\_log\_group\_name](#output\_custom\_eks\_cloudwatch\_log\_group\_name) | n/a |
| <a name="output_custom_eks_cluster_oidc_issuer_url"></a> [custom\_eks\_cluster\_oidc\_issuer\_url](#output\_custom\_eks\_cluster\_oidc\_issuer\_url) | n/a |
| <a name="output_custom_eks_cluster_role_arn"></a> [custom\_eks\_cluster\_role\_arn](#output\_custom\_eks\_cluster\_role\_arn) | n/a |
| <a name="output_custom_eks_cluster_role_id"></a> [custom\_eks\_cluster\_role\_id](#output\_custom\_eks\_cluster\_role\_id) | n/a |
| <a name="output_custom_eks_cluster_role_name"></a> [custom\_eks\_cluster\_role\_name](#output\_custom\_eks\_cluster\_role\_name) | n/a |
| <a name="output_custom_eks_cluster_security_group_id"></a> [custom\_eks\_cluster\_security\_group\_id](#output\_custom\_eks\_cluster\_security\_group\_id) | n/a |
| <a name="output_custom_eks_eip_public_nat_ids"></a> [custom\_eks\_eip\_public\_nat\_ids](#output\_custom\_eks\_eip\_public\_nat\_ids) | n/a |
| <a name="output_custom_eks_fargate_role_arn"></a> [custom\_eks\_fargate\_role\_arn](#output\_custom\_eks\_fargate\_role\_arn) | n/a |
| <a name="output_custom_eks_fargate_role_name"></a> [custom\_eks\_fargate\_role\_name](#output\_custom\_eks\_fargate\_role\_name) | n/a |
| <a name="output_custom_eks_internet_gateway_arn"></a> [custom\_eks\_internet\_gateway\_arn](#output\_custom\_eks\_internet\_gateway\_arn) | n/a |
| <a name="output_custom_eks_internet_gateway_id"></a> [custom\_eks\_internet\_gateway\_id](#output\_custom\_eks\_internet\_gateway\_id) | n/a |
| <a name="output_custom_eks_kubeconfig_certificate_authority_data"></a> [custom\_eks\_kubeconfig\_certificate\_authority\_data](#output\_custom\_eks\_kubeconfig\_certificate\_authority\_data) | n/a |
| <a name="output_custom_eks_kubeconfig_cmd"></a> [custom\_eks\_kubeconfig\_cmd](#output\_custom\_eks\_kubeconfig\_cmd) | n/a |
| <a name="output_custom_eks_node_group_arns"></a> [custom\_eks\_node\_group\_arns](#output\_custom\_eks\_node\_group\_arns) | n/a |
| <a name="output_custom_eks_node_group_ids"></a> [custom\_eks\_node\_group\_ids](#output\_custom\_eks\_node\_group\_ids) | n/a |
| <a name="output_custom_eks_node_role_arn"></a> [custom\_eks\_node\_role\_arn](#output\_custom\_eks\_node\_role\_arn) | n/a |
| <a name="output_custom_eks_node_role_id"></a> [custom\_eks\_node\_role\_id](#output\_custom\_eks\_node\_role\_id) | n/a |
| <a name="output_custom_eks_node_role_name"></a> [custom\_eks\_node\_role\_name](#output\_custom\_eks\_node\_role\_name) | n/a |
| <a name="output_custom_eks_platform_version"></a> [custom\_eks\_platform\_version](#output\_custom\_eks\_platform\_version) | n/a |
| <a name="output_custom_eks_public_nat_ids"></a> [custom\_eks\_public\_nat\_ids](#output\_custom\_eks\_public\_nat\_ids) | n/a |
| <a name="output_custom_eks_route_table_gateway_arns"></a> [custom\_eks\_route\_table\_gateway\_arns](#output\_custom\_eks\_route\_table\_gateway\_arns) | n/a |
| <a name="output_custom_eks_route_table_gateway_ids"></a> [custom\_eks\_route\_table\_gateway\_ids](#output\_custom\_eks\_route\_table\_gateway\_ids) | n/a |
| <a name="output_custom_eks_route_table_private_arns"></a> [custom\_eks\_route\_table\_private\_arns](#output\_custom\_eks\_route\_table\_private\_arns) | n/a |
| <a name="output_custom_eks_route_table_private_ids"></a> [custom\_eks\_route\_table\_private\_ids](#output\_custom\_eks\_route\_table\_private\_ids) | n/a |
| <a name="output_custom_eks_ssh_key_pair_name"></a> [custom\_eks\_ssh\_key\_pair\_name](#output\_custom\_eks\_ssh\_key\_pair\_name) | n/a |
| <a name="output_custom_eks_ssh_private_key"></a> [custom\_eks\_ssh\_private\_key](#output\_custom\_eks\_ssh\_private\_key) | n/a |
| <a name="output_custom_eks_ssh_private_key_s3_bucket_key"></a> [custom\_eks\_ssh\_private\_key\_s3\_bucket\_key](#output\_custom\_eks\_ssh\_private\_key\_s3\_bucket\_key) | n/a |
| <a name="output_custom_eks_ssh_public_key"></a> [custom\_eks\_ssh\_public\_key](#output\_custom\_eks\_ssh\_public\_key) | n/a |
| <a name="output_custom_eks_subnet_info"></a> [custom\_eks\_subnet\_info](#output\_custom\_eks\_subnet\_info) | n/a |
| <a name="output_custom_eks_vpc_arn"></a> [custom\_eks\_vpc\_arn](#output\_custom\_eks\_vpc\_arn) | n/a |
| <a name="output_custom_eks_vpc_default_network_acl_id"></a> [custom\_eks\_vpc\_default\_network\_acl\_id](#output\_custom\_eks\_vpc\_default\_network\_acl\_id) | n/a |
| <a name="output_custom_eks_vpc_default_route_table_id"></a> [custom\_eks\_vpc\_default\_route\_table\_id](#output\_custom\_eks\_vpc\_default\_route\_table\_id) | n/a |
| <a name="output_custom_eks_vpc_default_security_group_id"></a> [custom\_eks\_vpc\_default\_security\_group\_id](#output\_custom\_eks\_vpc\_default\_security\_group\_id) | n/a |
| <a name="output_custom_eks_vpc_id"></a> [custom\_eks\_vpc\_id](#output\_custom\_eks\_vpc\_id) | n/a |
| <a name="output_custom_eks_vpc_main_route_table_id"></a> [custom\_eks\_vpc\_main\_route\_table\_id](#output\_custom\_eks\_vpc\_main\_route\_table\_id) | n/a |
| <a name="output_simple_eks_addon_info"></a> [simple\_eks\_addon\_info](#output\_simple\_eks\_addon\_info) | n/a |
| <a name="output_simple_eks_api_server_endpoint"></a> [simple\_eks\_api\_server\_endpoint](#output\_simple\_eks\_api\_server\_endpoint) | n/a |
| <a name="output_simple_eks_cloudwatch_log_group_arn"></a> [simple\_eks\_cloudwatch\_log\_group\_arn](#output\_simple\_eks\_cloudwatch\_log\_group\_arn) | n/a |
| <a name="output_simple_eks_cloudwatch_log_group_id"></a> [simple\_eks\_cloudwatch\_log\_group\_id](#output\_simple\_eks\_cloudwatch\_log\_group\_id) | n/a |
| <a name="output_simple_eks_cloudwatch_log_group_name"></a> [simple\_eks\_cloudwatch\_log\_group\_name](#output\_simple\_eks\_cloudwatch\_log\_group\_name) | n/a |
| <a name="output_simple_eks_cluster_oidc_issuer_url"></a> [simple\_eks\_cluster\_oidc\_issuer\_url](#output\_simple\_eks\_cluster\_oidc\_issuer\_url) | n/a |
| <a name="output_simple_eks_cluster_role_arn"></a> [simple\_eks\_cluster\_role\_arn](#output\_simple\_eks\_cluster\_role\_arn) | n/a |
| <a name="output_simple_eks_cluster_role_id"></a> [simple\_eks\_cluster\_role\_id](#output\_simple\_eks\_cluster\_role\_id) | n/a |
| <a name="output_simple_eks_cluster_role_name"></a> [simple\_eks\_cluster\_role\_name](#output\_simple\_eks\_cluster\_role\_name) | n/a |
| <a name="output_simple_eks_cluster_security_group_id"></a> [simple\_eks\_cluster\_security\_group\_id](#output\_simple\_eks\_cluster\_security\_group\_id) | n/a |
| <a name="output_simple_eks_eip_public_nat_ids"></a> [simple\_eks\_eip\_public\_nat\_ids](#output\_simple\_eks\_eip\_public\_nat\_ids) | n/a |
| <a name="output_simple_eks_fargate_role_arn"></a> [simple\_eks\_fargate\_role\_arn](#output\_simple\_eks\_fargate\_role\_arn) | n/a |
| <a name="output_simple_eks_fargate_role_name"></a> [simple\_eks\_fargate\_role\_name](#output\_simple\_eks\_fargate\_role\_name) | n/a |
| <a name="output_simple_eks_internet_gateway_arn"></a> [simple\_eks\_internet\_gateway\_arn](#output\_simple\_eks\_internet\_gateway\_arn) | n/a |
| <a name="output_simple_eks_internet_gateway_id"></a> [simple\_eks\_internet\_gateway\_id](#output\_simple\_eks\_internet\_gateway\_id) | n/a |
| <a name="output_simple_eks_kubeconfig_certificate_authority_data"></a> [simple\_eks\_kubeconfig\_certificate\_authority\_data](#output\_simple\_eks\_kubeconfig\_certificate\_authority\_data) | n/a |
| <a name="output_simple_eks_kubeconfig_cmd"></a> [simple\_eks\_kubeconfig\_cmd](#output\_simple\_eks\_kubeconfig\_cmd) | n/a |
| <a name="output_simple_eks_node_group_arns"></a> [simple\_eks\_node\_group\_arns](#output\_simple\_eks\_node\_group\_arns) | n/a |
| <a name="output_simple_eks_node_group_ids"></a> [simple\_eks\_node\_group\_ids](#output\_simple\_eks\_node\_group\_ids) | n/a |
| <a name="output_simple_eks_node_role_arn"></a> [simple\_eks\_node\_role\_arn](#output\_simple\_eks\_node\_role\_arn) | n/a |
| <a name="output_simple_eks_node_role_id"></a> [simple\_eks\_node\_role\_id](#output\_simple\_eks\_node\_role\_id) | n/a |
| <a name="output_simple_eks_node_role_name"></a> [simple\_eks\_node\_role\_name](#output\_simple\_eks\_node\_role\_name) | n/a |
| <a name="output_simple_eks_platform_version"></a> [simple\_eks\_platform\_version](#output\_simple\_eks\_platform\_version) | n/a |
| <a name="output_simple_eks_public_nat_ids"></a> [simple\_eks\_public\_nat\_ids](#output\_simple\_eks\_public\_nat\_ids) | n/a |
| <a name="output_simple_eks_route_table_gateway_arns"></a> [simple\_eks\_route\_table\_gateway\_arns](#output\_simple\_eks\_route\_table\_gateway\_arns) | n/a |
| <a name="output_simple_eks_route_table_gateway_ids"></a> [simple\_eks\_route\_table\_gateway\_ids](#output\_simple\_eks\_route\_table\_gateway\_ids) | n/a |
| <a name="output_simple_eks_route_table_private_arns"></a> [simple\_eks\_route\_table\_private\_arns](#output\_simple\_eks\_route\_table\_private\_arns) | n/a |
| <a name="output_simple_eks_route_table_private_ids"></a> [simple\_eks\_route\_table\_private\_ids](#output\_simple\_eks\_route\_table\_private\_ids) | n/a |
| <a name="output_simple_eks_ssh_key_pair_name"></a> [simple\_eks\_ssh\_key\_pair\_name](#output\_simple\_eks\_ssh\_key\_pair\_name) | n/a |
| <a name="output_simple_eks_ssh_private_key"></a> [simple\_eks\_ssh\_private\_key](#output\_simple\_eks\_ssh\_private\_key) | n/a |
| <a name="output_simple_eks_ssh_private_key_s3_bucket_key"></a> [simple\_eks\_ssh\_private\_key\_s3\_bucket\_key](#output\_simple\_eks\_ssh\_private\_key\_s3\_bucket\_key) | n/a |
| <a name="output_simple_eks_ssh_public_key"></a> [simple\_eks\_ssh\_public\_key](#output\_simple\_eks\_ssh\_public\_key) | n/a |
| <a name="output_simple_eks_subnet_info"></a> [simple\_eks\_subnet\_info](#output\_simple\_eks\_subnet\_info) | n/a |
| <a name="output_simple_eks_vpc_arn"></a> [simple\_eks\_vpc\_arn](#output\_simple\_eks\_vpc\_arn) | n/a |
| <a name="output_simple_eks_vpc_default_network_acl_id"></a> [simple\_eks\_vpc\_default\_network\_acl\_id](#output\_simple\_eks\_vpc\_default\_network\_acl\_id) | n/a |
| <a name="output_simple_eks_vpc_default_route_table_id"></a> [simple\_eks\_vpc\_default\_route\_table\_id](#output\_simple\_eks\_vpc\_default\_route\_table\_id) | n/a |
| <a name="output_simple_eks_vpc_default_security_group_id"></a> [simple\_eks\_vpc\_default\_security\_group\_id](#output\_simple\_eks\_vpc\_default\_security\_group\_id) | n/a |
| <a name="output_simple_eks_vpc_id"></a> [simple\_eks\_vpc\_id](#output\_simple\_eks\_vpc\_id) | n/a |
| <a name="output_simple_eks_vpc_main_route_table_id"></a> [simple\_eks\_vpc\_main\_route\_table\_id](#output\_simple\_eks\_vpc\_main\_route\_table\_id) | n/a |
<!-- END_TF_DOCS -->