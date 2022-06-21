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

module "dapr-development-with-observability" {
  source = "../../../kubernetes/dapr"

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
  source = "../../../kubernetes/dapr"

  dapr_version                     = "1.7.4"
  create_dapr_system_namespace      = true
  create_dapr_apps_namespace        = true
  create_dapr_monitoring_namespace  = true
  deploy_redis_with_building_blocks = true
  deploy_zipkin                     = true
  deploy_prometheus_with_grafana    = true
  deploy_elasticsearch_with_kibana  = true
}