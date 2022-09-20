# Ingress NGINX Controller Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.30.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress-nginx-nlb-terminated"></a> [ingress-nginx-nlb-terminated](#module\_ingress-nginx-nlb-terminated) | ../../../aws/ingress-nginx | n/a |
| <a name="module_ingress-nginx-no-tls"></a> [ingress-nginx-no-tls](#module\_ingress-nginx-no-tls) | ../../../aws/ingress-nginx | n/a |
| <a name="module_ingress-nginx-terminated"></a> [ingress-nginx-terminated](#module\_ingress-nginx-terminated) | ../../../aws/ingress-nginx | n/a |

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
| <a name="output_ingress_nginx_nlb_terminated_controller_nlb_arn"></a> [ingress\_nginx\_nlb\_terminated\_controller\_nlb\_arn](#output\_ingress\_nginx\_nlb\_terminated\_controller\_nlb\_arn) | n/a |
| <a name="output_ingress_nginx_nlb_terminated_controller_nlb_hostname"></a> [ingress\_nginx\_nlb\_terminated\_controller\_nlb\_hostname](#output\_ingress\_nginx\_nlb\_terminated\_controller\_nlb\_hostname) | n/a |
| <a name="output_ingress_nginx_nlb_terminated_controller_nlb_name"></a> [ingress\_nginx\_nlb\_terminated\_controller\_nlb\_name](#output\_ingress\_nginx\_nlb\_terminated\_controller\_nlb\_name) | n/a |
| <a name="output_ingress_nginx_no_tls_controller_nlb_arn"></a> [ingress\_nginx\_no\_tls\_controller\_nlb\_arn](#output\_ingress\_nginx\_no\_tls\_controller\_nlb\_arn) | n/a |
| <a name="output_ingress_nginx_no_tls_controller_nlb_hostname"></a> [ingress\_nginx\_no\_tls\_controller\_nlb\_hostname](#output\_ingress\_nginx\_no\_tls\_controller\_nlb\_hostname) | n/a |
| <a name="output_ingress_nginx_no_tls_controller_nlb_name"></a> [ingress\_nginx\_no\_tls\_controller\_nlb\_name](#output\_ingress\_nginx\_no\_tls\_controller\_nlb\_name) | n/a |
| <a name="output_ingress_nginx_terminated_cert_manager_dns01_role_arn"></a> [ingress\_nginx\_terminated\_cert\_manager\_dns01\_role\_arn](#output\_ingress\_nginx\_terminated\_cert\_manager\_dns01\_role\_arn) | n/a |
| <a name="output_ingress_nginx_terminated_controller_nlb_arn"></a> [ingress\_nginx\_terminated\_controller\_nlb\_arn](#output\_ingress\_nginx\_terminated\_controller\_nlb\_arn) | n/a |
| <a name="output_ingress_nginx_terminated_controller_nlb_hostname"></a> [ingress\_nginx\_terminated\_controller\_nlb\_hostname](#output\_ingress\_nginx\_terminated\_controller\_nlb\_hostname) | n/a |
| <a name="output_ingress_nginx_terminated_controller_nlb_name"></a> [ingress\_nginx\_terminated\_controller\_nlb\_name](#output\_ingress\_nginx\_terminated\_controller\_nlb\_name) | n/a |
<!-- END_TF_DOCS -->