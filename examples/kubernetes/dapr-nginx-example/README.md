# Kubernetes Dapr NGINX Module Example

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dapr-nginx-controller"></a> [dapr-nginx-controller](#module\_dapr-nginx-controller) | ../../../kubernetes/dapr-nginx | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_redis-secret-copy-cmd"></a> [redis-secret-copy-cmd](#output\_redis-secret-copy-cmd) | n/a |
| <a name="output_redis-statestore-test"></a> [redis-statestore-test](#output\_redis-statestore-test) | n/a |
<!-- END_TF_DOCS -->