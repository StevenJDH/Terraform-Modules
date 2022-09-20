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

locals {
  enable_aws_acm             = var.enable_https_support && var.enable_nlb_termination
  enable_letsencrypt         = var.enable_https_support && !var.enable_nlb_termination
  ingress_nginx_namespace    = var.create_ingress_nginx_namespace ? kubernetes_namespace_v1.ingress-nginx[0].metadata[0].name : var.ingress_nginx_namespace
  cert_manager_namespace     = var.create_cert_manager_namespace && local.enable_letsencrypt ? kubernetes_namespace_v1.cert-manager[0].metadata[0].name : var.cert_manager_namespace
  cert_manager_issuer_name   = var.letsencrypt_enable_prod_issuer ? "letsencrypt-prod" : "letsencrypt-staging"
  register_nlb_alias_records = var.deploy_ingress_test && var.enable_https_support ? setunion(var.register_nlb_alias_records, ["test.${var.domain}"]) : var.register_nlb_alias_records
  cert_manager_name          = "cert-manager"
  dns01_federated_subject    = local.enable_letsencrypt && var.letsencrypt_enable_dns01_challenge ? format("system:serviceaccount:%s:%s", kubernetes_namespace_v1.cert-manager[0].metadata[0].name, local.cert_manager_name) : null

  ingress_test_annotations_required = {
    "ingress.kubernetes.io/rewrite-target" = "/"
  }

  ingress_test_annotations_optional = {
    cluster_issuer = !local.enable_letsencrypt ? {} : {
      "cert-manager.io/cluster-issuer" = local.cert_manager_issuer_name
    }
  }

  ingress_test_annotations = merge(
    local.ingress_test_annotations_required,
    local.ingress_test_annotations_optional["cluster_issuer"],
  )

  domain_validation_options = !local.enable_aws_acm ? {} : tomap({
    for dvo in aws_acm_certificate.this[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  })
}