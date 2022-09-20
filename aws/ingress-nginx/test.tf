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

resource "kubernetes_ingress_v1" "ingress-test" {
  count = var.deploy_ingress_test ? 1 : 0

  metadata {
    name = "ingress-test"
    annotations = local.ingress_test_annotations
  }
  spec {
    dynamic "tls" {
      for_each = local.enable_letsencrypt ? [true] : []

      content {
        hosts       = var.letsencrypt_enable_dns01_challenge ? ["*.${var.domain}"] : ["test.${var.domain}"]
        secret_name = "${replace(var.domain, ".", "-")}-tls-secret"
      }
    }
    ingress_class_name = "nginx"
    rule {
      # host required when tls block is set so it can be match against defined hosts.
      host = var.enable_https_support ? "test.${var.domain}" : "*"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.ingress-test[0].metadata[0].name
              port {
                number = kubernetes_service_v1.ingress-test[0].spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.ingress-nginx]
}

resource "kubernetes_service_v1" "ingress-test" {
  count = var.deploy_ingress_test ? 1 : 0

  metadata {
    name = "ingress-test-svc"
  }
  spec {
    selector = {
      app = kubernetes_pod_v1.ingress-test[0].metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = kubernetes_pod_v1.ingress-test[0].spec[0].container[0].port[0].container_port
    }
  }
}

resource "kubernetes_pod_v1" "ingress-test" {
  count = var.deploy_ingress_test ? 1 : 0

  metadata {
    name = "ingress-test"
    labels = {
      app = "ingress-test"
    }
  }
  spec {
    container {
      image = "nginx:latest"
      name  = "nginx"

      port {
        container_port = 80
      }
    }
  }
}