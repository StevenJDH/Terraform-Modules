# Kubernetes Dapr NGINX Module

## Usage

```hcl
module "dapr-nginx-controller" {
  source = "github.com/StevenJDH/Terraform-Modules//kubernetes/dapr-nginx?ref=main"

  nginx_version                = "4.1.4"
  create_dapr_nginx_namespace  = true
  nginx_replica_count          = 1
  create_redis_building_blocks = true
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
| [helm_release.nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.redis-pub-sub](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.redis-state-store](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.zipkin-config](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_ingress_v1.daprd-sidecar](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.dapr-nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_dapr_nginx_namespace"></a> [create\_dapr\_nginx\_namespace](#input\_create\_dapr\_nginx\_namespace) | Indicates whether or not to create a namespace for the Dapr NGINX. | `bool` | `true` | no |
| <a name="input_create_redis_building_blocks"></a> [create\_redis\_building\_blocks](#input\_create\_redis\_building\_blocks) | Indicates whether or not to create Redis building blocks for a state store component for persistence and restoration, and a pub/sub message broker component for async-style message delivery. The building blocks must be in the same namespace as the Dapr NGINX, and the redis secret must be copied over as well. | `bool` | `false` | no |
| <a name="input_dapr_custom_ingress_annotations"></a> [dapr\_custom\_ingress\_annotations](#input\_dapr\_custom\_ingress\_annotations) | Use annotations to configure some ingress options, for example, the rewrite-target annotation. Different Ingress controllers support different annotations. Review the documentation for the [NGINX Ingress controller](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations) to learn which annotations are supported. | `map(any)` | <pre>{<br>  "nginx.ingress.kubernetes.io/rewrite-target": "/"<br>}</pre> | no |
| <a name="input_dapr_custom_ingress_rules"></a> [dapr\_custom\_ingress\_rules](#input\_dapr\_custom\_ingress\_rules) | A list of paths (for example, /testpath), each of which has an associated backend defined with a service path, name, and port number. If custom rules are provided, make sure to keep the default rule or it will break the Dapr integration. | <pre>list(object({<br>    service_path = string<br>    service_name = string<br>    service_port = number<br>  }))</pre> | <pre>[<br>  {<br>    "service_name": "nginx-ingress-dapr",<br>    "service_path": "/",<br>    "service_port": 80<br>  }<br>]</pre> | no |
| <a name="input_dapr_ingress_hostname"></a> [dapr\_ingress\_hostname](#input\_dapr\_ingress\_hostname) | If a hostname is set, then the hostname must match the content of an incoming request before the load balancer directs traffic to the referenced Service. If one is not provided, then all incoming requests are accepted. | `string` | `null` | no |
| <a name="input_dapr_nginx_namespace"></a> [dapr\_nginx\_namespace](#input\_dapr\_nginx\_namespace) | Default namespace for the Dapr NGINX. | `string` | `"dapr-nginx"` | no |
| <a name="input_daprd_logging_level"></a> [daprd\_logging\_level](#input\_daprd\_logging\_level) | Sets the logging level of the daprd sidecar to either error, warn, info, or debug. | `string` | `"info"` | no |
| <a name="input_enable_zipkin_support"></a> [enable\_zipkin\_support](#input\_enable\_zipkin\_support) | Indicates whether or not to add support for Zipkin to read distributed tracing data sent by Dapr enabled NGINX. | `bool` | `true` | no |
| <a name="input_ingress_ip"></a> [ingress\_ip](#input\_ingress\_ip) | Used by cloud providers to connect the resulting `LoadBalancer` to a pre-existing static IP. | `string` | `null` | no |
| <a name="input_nginx_replica_count"></a> [nginx\_replica\_count](#input\_nginx\_replica\_count) | Sets the number of replicas for NGINX. For minikube setups or to reduce in general, set to 1. | `number` | `2` | no |
| <a name="input_nginx_version"></a> [nginx\_version](#input\_nginx\_version) | Version of NGINX to deploy if latest is not desired or version pinning is needed. | `string` | `"latest"` | no |
| <a name="input_zipkin_namespace"></a> [zipkin\_namespace](#input\_zipkin\_namespace) | Namespace where Zipkin can be found, for example, the default namespace for Dapr monitoring tools. | `string` | `"dapr-monitoring"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_redis-secret-copy-cmd"></a> [redis-secret-copy-cmd](#output\_redis-secret-copy-cmd) | n/a |
| <a name="output_redis-statestore-test"></a> [redis-statestore-test](#output\_redis-statestore-test) | n/a |
<!-- END_TF_DOCS -->