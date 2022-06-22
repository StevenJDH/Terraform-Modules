/*
 * This file is part of Terraform-Modules <https://github.com/StevenJDH/Terraform-Modules>.
 * Copyright (C) 2022 Steven Jenkins De Haro.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "kubernetes_namespace_v1" "dapr-nginx" {
  count = var.create_dapr_nginx_namespace ? 1 : 0

  metadata {
    name = var.dapr_nginx_namespace
  }
}

resource "helm_release" "nginx" {
  name       = "nginx-dapr"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.nginx_version == "latest" ? null : var.nginx_version
  namespace  = local.dapr_nginx_namespace

  values = [
    <<YAML
---
controller:
  replicaCount: ${var.nginx_replica_count}

  podAnnotations:
    dapr.io/enabled: "true"
    dapr.io/app-id: "nginx-ingress"
    dapr.io/app-port: "80"
    dapr.io/sidecar-listen-addresses: 0.0.0.0
    dapr.io/config: "zipkin"
    dapr.io/log-level: "${var.daprd_logging_level}"

  service:
    ## Set external traffic policy to: "Local" to preserve source IP on providers supporting it.
    externalTrafficPolicy: Local

    loadBalancerIP: ${var.ingress_ip == null ? "\"\"" : var.ingress_ip}

defaultBackend:
  enabled: false
    YAML
  ]
}

resource "kubernetes_ingress_v1" "daprd-sidecar" {
  wait_for_load_balancer = true

  metadata {
    name        = "ingress-dapr"
    namespace   = local.dapr_nginx_namespace
    annotations = var.dapr_custom_ingress_annotations
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = var.dapr_ingress_hostname
      http {
        dynamic "path" {
          for_each = tomap({for v in var.dapr_custom_ingress_rules : v.service_path => v})
          iterator = rule

          content {
            path = rule.value.service_path
            backend {
              service {
                name = rule.value.service_name
                port {
                  number = rule.value.service_port
                }
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.nginx]
}

resource "kubectl_manifest" "zipkin-config" {
  count = var.enable_zipkin_support? 1 : 0

  yaml_body = <<YAML
apiVersion: dapr.io/v1alpha1
kind: Configuration
metadata:
  name: zipkin
  namespace: ${local.dapr_nginx_namespace}
spec:
  tracing:
    samplingRate: "1"
    zipkin:
      endpointAddress: "http://zipkin.${var.zipkin_namespace}.svc.cluster.local:9411/api/v2/spans"
YAML
}

resource "kubectl_manifest" "redis-state-store" {
  count = var.create_redis_building_blocks ? 1 : 0

  yaml_body = <<YAML
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: statestore
  namespace: ${local.dapr_nginx_namespace}
spec:
  type: state.redis
  version: v1
  metadata:
  - name: redisHost
    value: redis-master.${var.redis_namespace}.svc.cluster.local:6379
  - name: redisPassword
    secretKeyRef:
      name: redis
      key: redis-password
  - name: enableTLS
    value: ${var.enable_redis_tls}
YAML
}

resource "kubectl_manifest" "redis-pub-sub" {
  count = var.create_redis_building_blocks ? 1 : 0

  yaml_body = <<YAML
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: pubsub
  namespace: ${local.dapr_nginx_namespace}
spec:
  type: pubsub.redis
  version: v1
  metadata:
  - name: redisHost
    value: redis-master.${var.redis_namespace}.svc.cluster.local:6379
  - name: redisPassword
    secretKeyRef:
      name: redis
      key: redis-password
  - name: enableTLS
    value: ${var.enable_redis_tls}
YAML
}