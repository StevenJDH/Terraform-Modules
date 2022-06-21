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

variable "create_dapr_system_namespace" {
  description = "Indicates whether or not to create a namespace for the Dapr system."
  type        = bool
  default     = true
}

variable "dapr_system_namespace" {
  description = "Default namespace for the Dapr system."
  type        = string
  default     = "dapr-system"
}

variable "create_dapr_apps_namespace" {
  description = "Indicates whether or not to create a namespace for Dapr enabled applications."
  type        = bool
  default     = true
}

variable "dapr_apps_namespace" {
  description = "Default namespace for Dapr enabled applications."
  type        = string
  default     = "dapr-apps"
}

variable "create_dapr_monitoring_namespace" {
  description = "Indicates whether or not to create a namespace for Dapr monitoring tools."
  type        = bool
  default     = true
}

variable "dapr_monitoring_namespace" {
  description = "Default namespace for Dapr monitoring tools."
  type        = string
  default     = "dapr-monitoring"
}

variable "enable_high_availability_mode" {
  description = "Enable high availability mode. Dapr can run with 3 replicas of each control plane pod in the Dapr system namespace for [production scenarios](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-production)."
  type        = bool
  default     = false
}

variable "dapr_version" {
  description = "Version of Dapr to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "log_as_json" {
  description = "Enables the Dapr system to use JSON-formatted logs."
  type        = bool
  default     = false
}

variable "deploy_redis_with_building_blocks" {
  description = "Deploy redis with building blocks for a state store component for persistence and restoration, and a pub/sub message broker component for async-style message delivery."
  type        = bool
  default     = false
}

variable "redis_version" {
  description = "Version of Redis to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "redis_replicas_replica_count" {
  description = "Sets the number of replicas for Redis Replicas. For minikube setups or to reduce in general, set to 1."
  type        = number
  default     = 3
}

variable "enable_redis_tls" {
  description = "Enable connecting to redis cache instances over TLS (ex - Azure Redis Cache)."
  type        = bool
  default     = false
}

variable "deploy_zipkin" {
  description = "Deploy Zipkin to read distributed tracing data sent by Dapr enabled applications who have added `dapr.io/config: \"zipkin\"` to their annotations."
  type        = bool
  default     = false
}

variable "zipkin_version" {
  description = "Version of Zipkin to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "deploy_prometheus_with_grafana" {
  description = "Deploy Prometheus to collect time-series data relating to the execution of the Dapr runtime itself, and Grafana to view those metrics on a dashboard."
  type        = bool
  default     = false
}

variable "prometheus_version" {
  description = "Version of Prometheus to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "grafana_version" {
  description = "Version of Grafana to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "enable_prometheus_grafana_persistent_volumes" {
  description = "Indicates whether or not to enable Prometheus and Grafana persistent volumes. For minikube setups or to exclude in general, set to false. See [here](https://docs.dapr.io/operations/monitoring/metrics/grafana/#configure-prometheus-as-data-source) to configure Prometheus as a data source and Grafana's dashboard."
  type        = bool
  default     = true
}

variable "deploy_elasticsearch_with_kibana" {
  description = "Deploy Elastic Search and Kibana to search and visualize logs in Kubernetes. See [here](https://docs.dapr.io/operations/monitoring/logging/fluentd/#search-logs) to configure Kibana."
  type        = bool
  default     = false
}

variable "elasticsearch_kibana_version" {
  description = "Version of Elastic Search and Kibana to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "elasticsearch_replica_count" {
  description = "Sets the number of replicas for Elastic Search. By default, 3 replicas are created which must be on different nodes. If the cluster has fewer than 3 nodes, specify a smaller number of replicas. For example, if using a minikube setup, set to 1."
  type        = number
  default     = 3
}

variable "enable_elasticsearch_persistent_volumes" {
  description = "Indicates whether or not to enable Elastic Search persistent volumes. For minikube setups or to exclude in general, set to false."
  type        = bool
  default     = true
}