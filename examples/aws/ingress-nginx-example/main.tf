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

module "ingress-nginx-no-tls" {
  source = "../../../aws/ingress-nginx"

  ingress_nginx_version = "4.2.5"
  deploy_ingress_test   = true

  tags = local.tags
}

module "ingress-nginx-nlb-terminated" {
  source = "../../../aws/ingress-nginx"

  ingress_nginx_version      = "4.2.5"
  enable_nlb_termination     = true
  deploy_ingress_test        = true
  enable_https_support       = true
  domain                     = "example.com"
  register_nlb_alias_records = ["example.com", "test.example.com"]

  tags = local.tags
}

module "ingress-nginx-terminated" {
  source = "../../../aws/ingress-nginx"

  ingress_nginx_version          = "4.2.5"
  cert_manager_version           = "1.9.1"
  enable_nlb_termination         = false
  enable_ssl_redirect            = true
  deploy_ingress_test            = true
  enable_https_support           = true
  domain                         = "example.com"
  register_nlb_alias_records     = ["example.com", "test.example.com"]
  letsencrypt_enable_prod_issuer = false # Set to true for properly signed certificate.
  letsencrypt_registration_email = "notify@example.com"

  # Using DNS01 instead of the simpler HTTP01 challenge type just to support
  # wildcard certificates. Requires an IAM OIDC Provider configured for IRSA.
  # https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa
  letsencrypt_enable_dns01_challenge = true
  letsencrypt_oidc_issuer_url        = data.aws_eks_cluster.selected.identity[0].oidc[0].issuer

  tags = local.tags
}