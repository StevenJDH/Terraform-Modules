# AWS EKS Fargate Logging Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks-fargate-cwl-logs"></a> [eks-fargate-cwl-logs](#module\_eks-fargate-cwl-logs) | ../../../aws/eks-fargate-logging | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fargate_cwl_for_fluent_bit_policy_arn"></a> [fargate\_cwl\_for\_fluent\_bit\_policy\_arn](#output\_fargate\_cwl\_for\_fluent\_bit\_policy\_arn) | n/a |
| <a name="output_fargate_cwl_for_fluent_bit_policy_id"></a> [fargate\_cwl\_for\_fluent\_bit\_policy\_id](#output\_fargate\_cwl\_for\_fluent\_bit\_policy\_id) | n/a |
<!-- END_TF_DOCS -->