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

output "zipkin-port-forward-cmd" {
  value = var.deploy_zipkin ? "kubectl port-forward svc/zipkin 9411:9411 -n ${local.dapr_monitoring_namespace}" : null
}

output "prometheus-server-endpoint" {
  value = var.deploy_prometheus_with_grafana ? "http://dapr-prom-prometheus-server.${local.dapr_monitoring_namespace}" : null
}

output "grafana-admin-password-lookup-cmd" {
  value = var.deploy_prometheus_with_grafana ? "kubectl get secret grafana -n ${var.dapr_monitoring_namespace} -o jsonpath={.data.admin-password} | base64 --decode ; echo" : null
}

output "grafana-port-forward-cmd" {
  value = var.deploy_prometheus_with_grafana ? "kubectl port-forward svc/grafana 8080:80 -n ${local.dapr_monitoring_namespace}" : null
}

output "kibana-port-forward-cmd" {
  value = var.deploy_elasticsearch_with_kibana ? "kubectl port-forward svc/kibana-kibana 5601:5601 -n ${local.dapr_monitoring_namespace}" : null
}