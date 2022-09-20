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

variable "create_ingress_nginx_namespace" {
  description = "Indicates whether or not to create a namespace for the Ingress NGINX controller."
  type        = bool
  default     = true
}

variable "ingress_nginx_namespace" {
  description = "Default namespace for the Ingress NGINX controller."
  type        = string
  default     = "ingress"
}

variable "ingress_nginx_version" {
  description = "Version of Ingress NGINX controller to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "ingress_nginx_replica_count" {
  description = "Sets the number of replicas for Ingress NGINX controller. For minikube setups or to reduce in general, set to 1."
  type        = number
  default     = 2
}

variable "ingress_ip" {
  description = "Used by cloud providers to connect the resulting `LoadBalancer` to a pre-existing static IP."
  type        = string
  default     = null
}

variable "domain" {
  description = "Domain to use for certificate. Must only be the apex part such as example.com. Subdomains will be protected by a wildcard automatically if `enable_nlb_termination` is set to true."
  type        = string
  default     = null
}

variable "register_nlb_alias_records" {
  description = "List of alias records to register in AWS Route 53 that will be associated with the Ingress NGINX controller load balancer."
  type        = set(string)
  default     = []
}

variable "enable_nlb_termination" {
  description = "Indicates whether or not to terminate TLS at the load balancer or not. If set to true, a free Amazon certificate is used, which is the native way of doing it. If set to false, a free Let's Encrypt certificate is used via Cert Manager, which requires using `cert-manager.io/cluster-issuer: letsencrypt-staging OR letsencrypt-prod` in the Ingress resource annotation for staging or prod endpoints along with the ingress TLS block. See [Supported Annotations](https://cert-manager.io/docs/usage/ingress/#supported-annotations) if something more is needed. Both termination approaches require `enable_https_support` to be enabled."
  type        = bool
  default     = true
}

variable "enable_ssl_redirect" {
  description = "Redirects HTTP requests to HTTPS. Applies only to Ingress NGINX controller termination since load balancer termination is currently always redirected using a workaround for AWS. It's recommended to keep this option always enabled when possible."
  type        = bool
  default     = true
}

variable "enable_internal_nlb" {
  description = "Indicates whether or not to enable internal-facing load balancer."
  type        = bool
  default     = false
}

variable "enable_https_support" {
  description = "Indicates whether or not to enable SSL/TLS support. See `enable_nlb_termination` for approach."
  type        = bool
  default     = false
}

variable "create_cert_manager_namespace" {
  description = "Indicates whether or not to create a namespace for the Cert Manager."
  type        = bool
  default     = true
}

variable "cert_manager_namespace" {
  description = "Default namespace for the Cert Manager."
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_version" {
  description = "Version of Cert Manager to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "cert_manager_count" {
  description = "Sets the number of replicas for Cert Manager."
  type        = number
  default     = 1
}

variable "letsencrypt_enable_prod_issuer" {
  description = "Indicates whether or not to use Staging or Production endpoints for the certificate issuing. The Let's Encrypt production issuer has [very strict rate limits](https://letsencrypt.org/docs/rate-limits). When experimenting and learning, it can be very easy to hit those limits. Because of that risk, start with the Let's Encrypt staging issuer, and once happy that it's working, switch to the production issuer. Any issues, see [Cert Manager Troubleshooting](https://cert-manager.io/docs/troubleshooting)."
  type        = bool
  default     = false
}

variable "letsencrypt_enable_dns01_challenge" {
  description = "Indicates whether or not to use DNS01 challenge type instead of HTTP01 to support wildcard certificates. For more information, see [ACME Challenge Types](https://letsencrypt.org/docs/challenge-types)."
  type        = bool
  default     = false
}

variable "letsencrypt_oidc_issuer_url" {
  description = "Issuer Url of the OpenID Connect identity provider. Requires the [IRSA](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa) module, or any other means that has created the provider."
  type        = string
  default     = null
}

variable "letsencrypt_registration_email" {
  description = "Email address used for ACME registration."
  type        = string
  default     = null
}

variable "deploy_ingress_test" {
  description = "Deploys test resources to validate if the Ingress NGINX controller setup is working using the a nginx pod that serves up a default web page. When done, make sure to set `deploy_ingress_test` to `false` to cleanup the test resources and avoid additional costs."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}