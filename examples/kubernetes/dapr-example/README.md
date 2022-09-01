# kubernetes Dapr Module Example

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
| <a name="module_dapr-development-with-observability"></a> [dapr-development-with-observability](#module\_dapr-development-with-observability) | ../../../kubernetes/dapr | n/a |
| <a name="module_dapr-production-with-observability"></a> [dapr-production-with-observability](#module\_dapr-production-with-observability) | ../../../kubernetes/dapr | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana-admin-password-lookup-cmd-dev"></a> [grafana-admin-password-lookup-cmd-dev](#output\_grafana-admin-password-lookup-cmd-dev) | n/a |
| <a name="output_grafana-admin-password-lookup-cmd-prod"></a> [grafana-admin-password-lookup-cmd-prod](#output\_grafana-admin-password-lookup-cmd-prod) | n/a |
| <a name="output_grafana-port-forward-cmd-dev"></a> [grafana-port-forward-cmd-dev](#output\_grafana-port-forward-cmd-dev) | n/a |
| <a name="output_grafana-port-forward-cmd-prod"></a> [grafana-port-forward-cmd-prod](#output\_grafana-port-forward-cmd-prod) | n/a |
| <a name="output_kibana-port-forward-cmd-dev"></a> [kibana-port-forward-cmd-dev](#output\_kibana-port-forward-cmd-dev) | n/a |
| <a name="output_kibana-port-forward-cmd-prod"></a> [kibana-port-forward-cmd-prod](#output\_kibana-port-forward-cmd-prod) | n/a |
| <a name="output_prometheus-server-endpoint-dev"></a> [prometheus-server-endpoint-dev](#output\_prometheus-server-endpoint-dev) | n/a |
| <a name="output_prometheus-server-endpoint-prod"></a> [prometheus-server-endpoint-prod](#output\_prometheus-server-endpoint-prod) | n/a |
| <a name="output_zipkin-port-forward-cmd-dev"></a> [zipkin-port-forward-cmd-dev](#output\_zipkin-port-forward-cmd-dev) | n/a |
| <a name="output_zipkin-port-forward-cmd-prod"></a> [zipkin-port-forward-cmd-prod](#output\_zipkin-port-forward-cmd-prod) | n/a |
<!-- END_TF_DOCS -->