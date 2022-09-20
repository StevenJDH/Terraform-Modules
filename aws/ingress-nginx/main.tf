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

resource "kubernetes_namespace_v1" "ingress-nginx" {
  count = var.create_ingress_nginx_namespace ? 1 : 0

  metadata {
    name = var.ingress_nginx_namespace
  }
}

# https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_version == "latest" ? null : var.ingress_nginx_version
  namespace  = local.ingress_nginx_namespace

  values = [
    <<YAML
---
controller:
  replicaCount: ${var.ingress_nginx_replica_count}

  containerPort:
    http: 80
    https: ${local.enable_aws_acm ? "80" : "443"}
    %{~ if local.enable_aws_acm ~}
    tohttps: 2443
    %{~ endif ~}

  service:
    # Set external traffic policy to: "Local" to preserve source IP on providers supporting it. Also needed for whitelisting.
    externalTrafficPolicy: Local
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "60"
      service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: ${local.enable_aws_acm ? "\"tcp\"" : "\"http\""}
      %{~ if local.enable_aws_acm ~}
      service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ${aws_acm_certificate.this[0].arn}
      service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
      %{~ endif ~}
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
    internal:
      enabled: ${var.enable_internal_nlb}
      annotations:
        # Create internal NLB.
        service.beta.kubernetes.io/aws-load-balancer-internal: "true"
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
        service.beta.kubernetes.io/aws-load-balancer-type: nlb
    targetPorts:
      http: ${local.enable_aws_acm ? "tohttps" : "http"}
      https: ${local.enable_aws_acm ? "http" : "https"}
    %{~ if var.ingress_ip != null ~}
    loadBalancerIP: ${var.ingress_ip}
    %{~ endif ~}

  # Will add custom configuration options to NGINX. https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap
  config:
    %{~ if local.enable_aws_acm ~}
    http-snippet: "server {listen 2443; return 308 https://$host$request_uri;}"
    %{~ endif ~}
    # Not needed for NLB termination because of http-snippet and port config.
    force-ssl-redirect: "false"
    ssl-redirect: "${local.enable_aws_acm ? false : var.enable_ssl_redirect}"
    # The use-forwarded-headers setting is for OSI L7 load balancers (e.g. ALBs), and
    # NLBs are L4 so we can set this to false, and since that is disabled,
    # proxy-real-ip-cidr becomes unnecessary.
    use-forwarded-headers: "false"
    #proxy-real-ip-cidr: "0.0.0.0/0"

defaultBackend:
  enabled: false
    YAML
  ]
}

resource "aws_route53_record" "this" {
  for_each = local.enable_aws_acm || local.enable_letsencrypt ? local.register_nlb_alias_records : []

  zone_id = data.aws_route53_zone.public-zone[0].zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = data.aws_lb.ingress-controller.dns_name
    zone_id                = data.aws_lb.ingress-controller.zone_id
    evaluate_target_health = false
  }
}