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

variable "create_dapr_nginx_namespace" {
  description = "Indicates whether or not to create a namespace for the Dapr NGINX."
  type        = bool
  default     = true
}

variable "dapr_nginx_namespace" {
  description = "Default namespace for the Dapr NGINX."
  type        = string
  default     = "dapr-nginx"
}

variable "nginx_version" {
  description = "Version of NGINX to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "nginx_replica_count" {
  description = "Sets the number of replicas for NGINX. For minikube setups or to reduce in general, set to 1."
  type        = number
  default     = 2
}

variable "dapr_ingress_hostname" {
  description = "If a hostname is set, then the hostname must match the content of an incoming request before the load balancer directs traffic to the referenced Service. If one is not provided, then all incoming requests are accepted."
  type        = string
  default     = null
}

variable "ingress_ip" {
  description = "Used by cloud providers to connect the resulting `LoadBalancer` to a pre-existing static IP."
  type        = string
  default     = null
}

variable "dapr_custom_ingress_annotations" {
  description = "Use annotations to configure some ingress options, for example, the rewrite-target annotation. Different Ingress controllers support different annotations. Review the documentation for the [NGINX Ingress controller](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations) to learn which annotations are supported."
  type = map(any)
  default = {
    "nginx.ingress.kubernetes.io/rewrite-target" = "/"
  }
}

variable "dapr_custom_ingress_rules" {
  description = "A list of paths (for example, /testpath), each of which has an associated backend defined with a service path, name, and port number. If custom rules are provided, make sure to keep the default rule or it will break the Dapr integration."
  type = list(object({
    service_path = string
    service_name = string
    service_port = number
  }))
  default = [{
    service_path = "/"
    service_name = "nginx-ingress-dapr"
    service_port = 80
  },]
}

variable "enable_zipkin_support" {
  description = "Indicates whether or not to add support for Zipkin to read distributed tracing data sent by Dapr enabled NGINX."
  type        = bool
  default     = true
}

variable "zipkin_namespace" {
  description = "Namespace where Zipkin can be found, for example, the default namespace for Dapr monitoring tools."
  type        = string
  default     = "dapr-monitoring"
}

variable "daprd_logging_level" {
  description = "Sets the logging level of the daprd sidecar to either error, warn, info, or debug."
  type        = string
  default     = "info"
  validation {
    condition     = contains(["error", "warn", "info", "debug"], var.daprd_logging_level)
    error_message = "The logging level can only be error, warn, info, or debug."
  }
}

variable "create_redis_building_blocks" {
  description = "Indicates whether or not to create Redis building blocks for a state store component for persistence and restoration, and a pub/sub message broker component for async-style message delivery. The building blocks must be in the same namespace as the Dapr NGINX, and the redis secret must be copied over as well."
  type        = bool
  default     = false
}