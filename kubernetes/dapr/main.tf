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

resource "kubernetes_namespace_v1" "dapr-system" {
  count = var.create_dapr_system_namespace ? 1 : 0

  metadata {
    name = var.dapr_system_namespace
  }
}

resource "helm_release" "dapr" {
  name       = "dapr"
  repository = "https://dapr.github.io/helm-charts"
  chart      = "dapr"
  version    = var.dapr_version == "latest" ? null : var.dapr_version
  namespace  = local.dapr_system_namespace

  set {
    name  = "global.logAsJson"
    value = var.log_as_json
  }

  set {
    name  = "global.ha.enabled"
    value = var.enable_high_availability_mode
  }
}

resource "kubernetes_namespace_v1" "dapr-apps" {
  count = var.create_dapr_apps_namespace ? 1 : 0

  metadata {
    name = var.dapr_apps_namespace
  }
}

resource "helm_release" "redis" {
  count = var.deploy_redis_with_building_blocks ? 1 : 0

  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = var.redis_version == "latest" ? null : var.redis_version
  namespace  = local.dapr_apps_namespace

  set {
    name = "replica.replicaCount"
    value = var.redis_replicas_replica_count
  }
}

resource "kubectl_manifest" "redis-state-store" {
  count = var.deploy_redis_with_building_blocks ? 1 : 0

  yaml_body = <<YAML
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: statestore
  namespace: ${helm_release.redis[0].namespace}
spec:
  type: state.redis
  version: v1
  metadata:
  - name: redisHost
    value: redis-master.${helm_release.redis[0].namespace}.svc.cluster.local:6379
  - name: redisPassword
    secretKeyRef:
      name: redis
      key: redis-password
  - name: enableTLS
    value: ${var.enable_redis_tls}
YAML

  depends_on = [helm_release.dapr]
}

resource "kubectl_manifest" "redis-pub-sub" {
  count = var.deploy_redis_with_building_blocks ? 1 : 0

  yaml_body = <<YAML
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: pubsub
  namespace: ${helm_release.redis[0].namespace}
spec:
  type: pubsub.redis
  version: v1
  metadata:
  - name: redisHost
    value: redis-master.${helm_release.redis[0].namespace}.svc.cluster.local:6379
  - name: redisPassword
    secretKeyRef:
      name: redis
      key: redis-password
  - name: enableTLS
    value: ${var.enable_redis_tls}
YAML

  depends_on = [helm_release.dapr]
}