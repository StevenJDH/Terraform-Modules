# kubernetes KEDA Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.33.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_keda-on-aws-eks"></a> [keda-on-aws-eks](#module\_keda-on-aws-eks) | ../../../kubernetes/keda | n/a |
| <a name="module_keda-on-azure-aks"></a> [keda-on-azure-aks](#module\_keda-on-azure-aks) | ../../../kubernetes/keda | n/a |
| <a name="module_keda-on-k8s"></a> [keda-on-k8s](#module\_keda-on-k8s) | ../../../kubernetes/keda | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [azurerm_kubernetes_cluster.selected](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_cluster_name"></a> [aks\_cluster\_name](#input\_aks\_cluster\_name) | Name of the Azure AKS cluster. | `string` | `null` | no |
| <a name="input_aks_cluster_resource_group_name"></a> [aks\_cluster\_resource\_group\_name](#input\_aks\_cluster\_resource\_group\_name) | Name of the Resource Group in which the AKS cluster exists. | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region. | `string` | `"eu-west-3"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the AWS EKS cluster. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->