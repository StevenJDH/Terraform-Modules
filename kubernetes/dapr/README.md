# Kubernetes Dapr Module

## Usage

```hcl
module "dapr-development-with-observability" {
  source = "github.com/StevenJDH/Terraform-Modules//kubernetes/dapr?ref=main"

  dapr_version                     = "1.7.4"
  create_dapr_system_namespace      = true
  create_dapr_apps_namespace        = true
  create_dapr_monitoring_namespace  = true
  deploy_redis_with_building_blocks = true
  redis_replicas_replica_count      = 1
  deploy_zipkin                     = true
  deploy_prometheus_with_grafana    = true
  deploy_elasticsearch_with_kibana  = true
  elasticsearch_replica_count       = 1

  enable_prometheus_grafana_persistent_volumes = false
  enable_elasticsearch_persistent_volumes      = false
}

module "dapr-production-with-observability" {
  source = "github.com/StevenJDH/Terraform-Modules//kubernetes/dapr?ref=main"

  dapr_version                     = "1.7.4"
  create_dapr_system_namespace      = true
  create_dapr_apps_namespace        = true
  create_dapr_monitoring_namespace  = true
  deploy_redis_with_building_blocks = true
  deploy_zipkin                     = true
  deploy_prometheus_with_grafana    = true
  deploy_elasticsearch_with_kibana  = true
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.6 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 1.14 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.dapr](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.elasticsearch](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.grafana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kibana](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.redis](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.redis-pub-sub](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.redis-state-store](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.zipkin-config](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_deployment.zipkin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_namespace.dapr-apps](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.dapr-monitoring](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.dapr-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service.zipkin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_dapr_apps_namespace"></a> [create\_dapr\_apps\_namespace](#input\_create\_dapr\_apps\_namespace) | Indicates whether or not to create a namespace for Dapr enabled applications. | `bool` | `true` | no |
| <a name="input_create_dapr_monitoring_namespace"></a> [create\_dapr\_monitoring\_namespace](#input\_create\_dapr\_monitoring\_namespace) | Indicates whether or not to create a namespace for Dapr monitoring tools. | `bool` | `true` | no |
| <a name="input_create_dapr_system_namespace"></a> [create\_dapr\_system\_namespace](#input\_create\_dapr\_system\_namespace) | Indicates whether or not to create a namespace for the Dapr system. | `bool` | `true` | no |
| <a name="input_dapr_apps_namespace"></a> [dapr\_apps\_namespace](#input\_dapr\_apps\_namespace) | Default namespace for Dapr enabled applications. | `string` | `"dapr-apps"` | no |
| <a name="input_dapr_monitoring_namespace"></a> [dapr\_monitoring\_namespace](#input\_dapr\_monitoring\_namespace) | Default namespace for Dapr monitoring tools. | `string` | `"dapr-monitoring"` | no |
| <a name="input_dapr_system_namespace"></a> [dapr\_system\_namespace](#input\_dapr\_system\_namespace) | Default namespace for the Dapr system. | `string` | `"dapr-system"` | no |
| <a name="input_dapr_version"></a> [dapr\_version](#input\_dapr\_version) | Version of Dapr to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_deploy_elasticsearch_with_kibana"></a> [deploy\_elasticsearch\_with\_kibana](#input\_deploy\_elasticsearch\_with\_kibana) | Deploy Elastic Search and Kibana to search and visualize logs in Kubernetes. See [here](https://docs.dapr.io/operations/monitoring/logging/fluentd/#search-logs) to configure Kibana. | `bool` | `false` | no |
| <a name="input_deploy_prometheus_with_grafana"></a> [deploy\_prometheus\_with\_grafana](#input\_deploy\_prometheus\_with\_grafana) | Deploy Prometheus to collect time-series data relating to the execution of the Dapr runtime itself, and Grafana to view those metrics on a dashboard. | `bool` | `false` | no |
| <a name="input_deploy_redis_with_building_blocks"></a> [deploy\_redis\_with\_building\_blocks](#input\_deploy\_redis\_with\_building\_blocks) | Deploy redis with building blocks for a state store component for persistence and restoration, and a pub/sub message broker component for async-style message delivery. | `bool` | `false` | no |
| <a name="input_deploy_zipkin"></a> [deploy\_zipkin](#input\_deploy\_zipkin) | Deploy Zipkin to read distributed tracing data sent by Dapr enabled applications who have added `dapr.io/config: "zipkin"` to their annotations. | `bool` | `false` | no |
| <a name="input_elasticsearch_kibana_version"></a> [elasticsearch\_kibana\_version](#input\_elasticsearch\_kibana\_version) | Version of Elastic Search and Kibana to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_elasticsearch_replica_count"></a> [elasticsearch\_replica\_count](#input\_elasticsearch\_replica\_count) | Sets the number of replicas for Elastic Search. By default, 3 replicas are created which must be on different nodes. If the cluster has fewer than 3 nodes, specify a smaller number of replicas. For example, if using a minikube setup, set to 1. | `number` | `3` | no |
| <a name="input_enable_elasticsearch_persistent_volumes"></a> [enable\_elasticsearch\_persistent\_volumes](#input\_enable\_elasticsearch\_persistent\_volumes) | Indicates whether or not to enable Elastic Search persistent volumes. For minikube setups or to exclude in general, set to false. | `bool` | `true` | no |
| <a name="input_enable_high_availability_mode"></a> [enable\_high\_availability\_mode](#input\_enable\_high\_availability\_mode) | Enable high availability mode. Dapr can run with 3 replicas of each control plane pod in the Dapr system namespace for [production scenarios](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-production). | `bool` | `false` | no |
| <a name="input_enable_prometheus_grafana_persistent_volumes"></a> [enable\_prometheus\_grafana\_persistent\_volumes](#input\_enable\_prometheus\_grafana\_persistent\_volumes) | Indicates whether or not to enable Prometheus and Grafana persistent volumes. For minikube setups or to exclude in general, set to false. See [here](https://docs.dapr.io/operations/monitoring/metrics/grafana/#configure-prometheus-as-data-source) to configure Prometheus as a data source and Grafana's dashboard. | `bool` | `true` | no |
| <a name="input_enable_redis_tls"></a> [enable\_redis\_tls](#input\_enable\_redis\_tls) | Enable connecting to redis cache instances over TLS (ex - Azure Redis Cache). | `bool` | `false` | no |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | Version of Grafana to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_log_as_json"></a> [log\_as\_json](#input\_log\_as\_json) | Enables the Dapr system to use JSON-formatted logs. | `bool` | `false` | no |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | Version of Prometheus to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_redis_replicas_replica_count"></a> [redis\_replicas\_replica\_count](#input\_redis\_replicas\_replica\_count) | Sets the number of replicas for Redis Replicas. For minikube setups or to reduce in general, set to 1. | `number` | `3` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | Version of Redis to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_zipkin_version"></a> [zipkin\_version](#input\_zipkin\_version) | Version of Zipkin to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana-admin-password-lookup-cmd"></a> [grafana-admin-password-lookup-cmd](#output\_grafana-admin-password-lookup-cmd) | n/a |
| <a name="output_grafana-port-forward-cmd"></a> [grafana-port-forward-cmd](#output\_grafana-port-forward-cmd) | n/a |
| <a name="output_kibana-port-forward-cmd"></a> [kibana-port-forward-cmd](#output\_kibana-port-forward-cmd) | n/a |
| <a name="output_prometheus-server-endpoint"></a> [prometheus-server-endpoint](#output\_prometheus-server-endpoint) | n/a |
| <a name="output_zipkin-port-forward-cmd"></a> [zipkin-port-forward-cmd](#output\_zipkin-port-forward-cmd) | n/a |
<!-- END_TF_DOCS -->