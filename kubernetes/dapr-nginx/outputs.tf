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

output "redis-secret-copy-cmd" {
  value = var.create_redis_building_blocks ? "Run the following command and restart the NGINX pod(s): kubectl get secret redis -n ${var.redis_namespace} -o yaml | sed 's/namespace: .*/namespace: ${local.dapr_nginx_namespace}/' | kubectl apply -f -" : null
}

output "redis-statestore-test" {
  value = var.create_redis_building_blocks ? "Run the following test, 'HTTP/1.1 204 No Content' means success: curl -X DELETE http://${var.dapr_ingress_hostname == null ? "localhost" : var.dapr_ingress_hostname}/v1.0/state/statestore/test -I" : null
}