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

output "zipkin-port-forward-cmd-dev" {
  value = module.dapr-development-with-observability.zipkin-port-forward-cmd
}

output "prometheus-server-endpoint-dev" {
  value = module.dapr-development-with-observability.prometheus-server-endpoint
}

output "grafana-admin-password-lookup-cmd-dev" {
  value = module.dapr-development-with-observability.grafana-admin-password-lookup-cmd
}

output "grafana-port-forward-cmd-dev" {
  value = module.dapr-development-with-observability.grafana-port-forward-cmd
}

output "kibana-port-forward-cmd-dev" {
  value = module.dapr-development-with-observability.kibana-port-forward-cmd
}

output "zipkin-port-forward-cmd-prod" {
  value = module.dapr-production-with-observability.zipkin-port-forward-cmd
}

output "prometheus-server-endpoint-prod" {
  value = module.dapr-production-with-observability.prometheus-server-endpoint
}

output "grafana-admin-password-lookup-cmd-prod" {
  value = module.dapr-production-with-observability.grafana-admin-password-lookup-cmd
}

output "grafana-port-forward-cmd-prod" {
  value = module.dapr-production-with-observability.grafana-port-forward-cmd
}

output "kibana-port-forward-cmd-prod" {
  value = module.dapr-production-with-observability.kibana-port-forward-cmd
}