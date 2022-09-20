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

data "aws_route53_zone" "public-zone" {
  count = local.enable_aws_acm || local.enable_letsencrypt ? 1 : 0

  name         = var.domain
  private_zone = false
}

data "kubernetes_service_v1" "ingress-controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = local.ingress_nginx_namespace
  }

  depends_on = [helm_release.ingress-nginx]
}

data "aws_lb" "ingress-controller" {
  name = regex("^(?P<name>.+)-.+\\.elb\\..+\\.amazonaws\\.com", data.kubernetes_service_v1.ingress-controller.status[0].load_balancer[0].ingress[0].hostname)["name"]
}

data "aws_iam_openid_connect_provider" "selected" {
  count = local.enable_letsencrypt && var.letsencrypt_enable_dns01_challenge ? 1 : 0

  url = var.letsencrypt_oidc_issuer_url
}