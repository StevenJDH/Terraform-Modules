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

resource "kubernetes_namespace" "dapr-monitoring" {
  count = var.create_dapr_monitoring_namespace ? 1 : 0

  metadata {
    name = var.dapr_monitoring_namespace
  }
}

resource "kubernetes_deployment" "zipkin" {
  count = var.deploy_zipkin ? 1 : 0

  metadata {
    name = "zipkin"
    namespace = local.dapr_monitoring_namespace
    labels = {
      app = "zipkin"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "zipkin"
      }
    }
    template {
      metadata {
        labels = {
          app = "zipkin"
        }
      }
      spec {
        container {
          name = "zipkin"
          image = "openzipkin/zipkin:${var.zipkin_version}"
          port {
            container_port = 9411
            protocol = "TCP"
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "2"
              memory = "1Gi"
            }
          }
        }
        restart_policy = "Always"
      }
    }
  }

  depends_on = [kubectl_manifest.zipkin-config]
}

resource "kubernetes_service" "zipkin" {
  count = var.deploy_zipkin ? 1 : 0

  metadata {
    name = kubernetes_deployment.zipkin[0].metadata[0].name
    namespace = kubernetes_deployment.zipkin[0].metadata[0].namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.zipkin[0].spec[0].template[0].metadata[0].labels.app
    }
    port {
      protocol = "TCP"
      port = kubernetes_deployment.zipkin[0].spec[0].template[0].spec[0].container[0].port[0].container_port
      target_port = kubernetes_deployment.zipkin[0].spec[0].template[0].spec[0].container[0].port[0].container_port
    }
  }
}

resource "kubectl_manifest" "zipkin-config" {
  count = var.deploy_zipkin ? 1 : 0

  yaml_body = <<YAML
apiVersion: dapr.io/v1alpha1
kind: Configuration
metadata:
  name: zipkin
  namespace: ${local.dapr_apps_namespace}
spec:
  tracing:
    samplingRate: "1"
    zipkin:
      endpointAddress: "http://zipkin.${local.dapr_monitoring_namespace}.svc.cluster.local:9411/api/v2/spans"
YAML

  depends_on = [helm_release.dapr]
}

resource "helm_release" "prometheus" {
  count = var.deploy_prometheus_with_grafana ? 1 : 0

  name       = "dapr-prom"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus_version == "latest" ? null : var.prometheus_version
  namespace  = local.dapr_monitoring_namespace

  set {
    name  = "alertmanager.persistentVolume.enable"
    value = var.enable_prometheus_grafana_persistent_volumes
  }

  set {
    name  = "pushgateway.persistentVolume.enabled"
    value = var.enable_prometheus_grafana_persistent_volumes
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = var.enable_prometheus_grafana_persistent_volumes
  }

  # Workaround fix as per https://github.com/prometheus-community/helm-charts/issues/467
  set {
    name = "nodeExporter.hostRootfs"
    value = false
  }
}

resource "helm_release" "grafana" {
  count = var.deploy_prometheus_with_grafana ? 1 : 0

  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.grafana_version == "latest" ? null : var.grafana_version
  namespace  = helm_release.prometheus[0].namespace

  set {
    name  = "persistence.enabled"
    value = var.enable_prometheus_grafana_persistent_volumes
  }
}

resource "helm_release" "elasticsearch" {
  count = var.deploy_elasticsearch_with_kibana ? 1 : 0

  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = var.elasticsearch_kibana_version== "latest" ? null : var.elasticsearch_kibana_version
  namespace  = local.dapr_monitoring_namespace

  set {
    name  = "replicas"
    value = var.elasticsearch_replica_count
  }

  set {
    name  = "persistence.enabled"
    value = var.enable_elasticsearch_persistent_volumes
  }
}

resource "helm_release" "kibana" {
  count = var.deploy_elasticsearch_with_kibana ? 1 : 0

  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = var.elasticsearch_kibana_version== "latest" ? null : var.elasticsearch_kibana_version
  namespace  = helm_release.elasticsearch[0].namespace
}