# Kubernetes KEDA Module
KEDA is a Kubernetes-based Event Driven Autoscaler that can drive the scaling of any container in Kubernetes based on the number of events needing to be processed. It is a single-purpose and lightweight component that can be added into any Kubernetes cluster. KEDA works alongside standard Kubernetes components like the Horizontal Pod Autoscaler and can extend functionality without overwriting or duplication. With KEDA, selected apps can be explicitly map to use event-driven scaling with other apps continuing to function without it. This makes KEDA a flexible and safe option to run alongside other Kubernetes applications and frameworks.

## Feature highlights

* Support for AWS IAM Roles for Service Accounts (IRSA). Requires KEDA 2.8.0 or above.
* Support for Azure AD Workload Identity (AZWI). Requires KEDA 2.8.0 or above.
* Support for unmanaged Kubernetes environments.
* Read only root filesystem for additional security.

## Usage

```hcl
module "keda-on-k8s" {
  source = "github.com/StevenJDH/Terraform-Modules//kubernetes/keda?ref=main"

  keda_version          = "2.8.1"
  create_keda_namespace = true
}

module "keda-on-aws-eks" {
  source = "github.com/StevenJDH/Terraform-Modules//kubernetes/keda?ref=main"

  keda_version          = "2.8.1"
  create_keda_namespace = true
  enable_irsa           = true
  irsa_role_arn         = "arn:aws:iam::000000000000:role/example-irsa-role"
}

module "keda-on-azure-aks" {
  source = "github.com/StevenJDH/Terraform-Modules//kubernetes/keda?ref=main"

  keda_version          = "2.8.1"
  create_keda_namespace = true
  enable_azwi_system    = true
  azwi_client_id        = "9ec033ad-d050-416f-b376-09a3527d5edb"
}
```

## Uninstalling
To remove KEDA, first remove any `ScaledObjects` and `ScaledJobs` that have been created. The following command will remove these resources in all namespaces:

```bash
kubectl delete --all scaledobjects,scaledjobs -A
```

After, KEDA can be uninstalled. The `TriggerAuthentication` resources will be cleaned up automatically. 

**Note:** Uninstall KEDA without first deleting any `ScaledObject` or `ScaledJob` resources that have been created will cause these resources to become orphaned, and Terraform might complete with a message saying:

```bash
Error: uninstallation completed with 1 error(s): timed out waiting for the condition
```

In this situation, patch the resources to remove their finalizers using the below commands (Windows users can use git bash or WSL). Once this is done, they will be automatically removed by Kubernetes.

```bash
namespace=test

for pod in $(kubectl get scaledobjects -o name -n $namespace); do
  kubectl patch $pod -p '{"metadata":{"finalizers":null}}' --type=merge -n $namespace
done

for pod in $(kubectl get scaledjobs -o name -n $namespace); do
  kubectl patch $pod -p '{"metadata":{"finalizers":null}}' --type=merge -n $namespace
done
```

Finally, run `terraform destroy` again to finish cleaning up the state.

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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.6 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.keda](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azwi_client_id"></a> [azwi\_client\_id](#input\_azwi\_client\_id) | The clientId of the KEDA app registration in Azure AD for the azwi system. These will be set as an annotation on the KEDA service account. Tenant Id is set automatically. For `TriggerAuthentication` resources, set `spec.podIdentity.provider` to `azure-workload` and `spec.podIdentity.identityId` with a separate app registration clientId along with the needed Azure role associations to not share privileges. See [Re-use credentials and delegate auth with TriggerAuthentication](https://keda.sh/docs/2.8/concepts/authentication/#re-use-credentials-and-delegate-auth-with-triggerauthentication) for more information. | `string` | `null` | no |
| <a name="input_create_keda_namespace"></a> [create\_keda\_namespace](#input\_create\_keda\_namespace) | Indicates whether or not to create a namespace for KEDA. | `bool` | `true` | no |
| <a name="input_enable_azwi_system"></a> [enable\_azwi\_system](#input\_enable\_azwi\_system) | Indicates whether or not to use Azure AD Workload Identity system (AZWI) for federated access without having to manage passwords in secrets. Requires [Azure Workload Identity Module](https://github.com/StevenJDH/Terraform-Modules/tree/main/azure/workload-identity) installed or made available through other means. Conflicts with `enable_irsa`. | `bool` | `false` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Indicates whether or not to use AWS IAM Roles for Service Accounts (IRSA) for federated access without having to manage passwords in secrets. Requires [AWS IAM Roles for Service Accounts (IRSA) Module](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa) installed or made available through other means. Conflicts with `enable_azwi_system`. | `bool` | `false` | no |
| <a name="input_irsa_role_arn"></a> [irsa\_role\_arn](#input\_irsa\_role\_arn) | ARN of an IAM role with a web identity provider. This will be set as an annotation on the KEDA service account. For `TriggerAuthentication` resources, set `spec.podIdentity.provider` to `aws-eks` and use a separate app specific role along with the needed policy associations to not share privileges. See [Re-use credentials and delegate auth with TriggerAuthentication](https://keda.sh/docs/2.8/concepts/authentication/#re-use-credentials-and-delegate-auth-with-triggerauthentication) for more information. | `string` | `null` | no |
| <a name="input_keda_namespace"></a> [keda\_namespace](#input\_keda\_namespace) | Default namespace for KEDA. | `string` | `"keda"` | no |
| <a name="input_keda_version"></a> [keda\_version](#input\_keda\_version) | Version of KEDA to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_token_expiration"></a> [token\_expiration](#input\_token\_expiration) | Sets the KEDA service account token expiration in seconds for the azwi system and irsa. This will be set as an annotation on the KEDA service account. | `string` | `"3600"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->