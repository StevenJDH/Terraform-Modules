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

resource "kubernetes_namespace_v1" "cert-manager" {
  count = var.create_cert_manager_namespace && local.enable_letsencrypt ? 1 : 0

  metadata {
    name = var.cert_manager_namespace
  }
}

# https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml
resource "helm_release" "cert-manager" {
  count = local.enable_letsencrypt ? 1 : 0

  name       = local.cert_manager_name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_version == "latest" ? null : var.cert_manager_version
  namespace  = local.cert_manager_namespace

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "replicaCount"
    value = var.cert_manager_count
  }

  dynamic "set" {
    for_each = var.letsencrypt_enable_dns01_challenge ? [true] : []

    content {
      name  = "securityContext.fsGroup"
      value = "1001"
    }
  }

  dynamic "set" {
    for_each = var.letsencrypt_enable_dns01_challenge ? [true] : []

    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.cert-manager-dns01[0].arn
    }
  }
}

resource "kubectl_manifest" "letsencrypt-issuer" {
  count = local.enable_letsencrypt ? 1 : 0

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${local.cert_manager_issuer_name}
  namespace: ${kubernetes_namespace_v1.cert-manager[0].metadata[0].name}
spec:
  acme:
    # The ACME server URL.
    server: ${var.letsencrypt_enable_prod_issuer ? "https://acme-v02.api.letsencrypt.org/directory" : "https://acme-staging-v02.api.letsencrypt.org/directory"}
    # Email address used for ACME registration.
    email: ${var.letsencrypt_registration_email}
    # Name of a secret used to store the ACME account private key.
    privateKeySecretRef:
      name: ${local.cert_manager_issuer_name}
    # Enable the HTTP-01 challenge provider.
    solvers:
      %{~ if !var.letsencrypt_enable_dns01_challenge ~}
      - http01:
          ingress:
            class: nginx
      %{~ else ~}
      - selector:
          dnsZones:
            - ${var.domain}
        dns01:
          route53:
            region: global
            hostedZoneID: ${data.aws_route53_zone.public-zone[0].zone_id}
      %{~ endif ~}
YAML

  depends_on = [helm_release.cert-manager]
}

resource "random_id" "cert-manager-dns01" {
  count = local.enable_letsencrypt && var.letsencrypt_enable_dns01_challenge ? 1 : 0

  byte_length = 4
}

resource "aws_iam_role" "cert-manager-dns01" {
  count = local.enable_letsencrypt && var.letsencrypt_enable_dns01_challenge ? 1 : 0

  name        = "irsa-role-cert-manager-dns01-${random_id.cert-manager-dns01[0].hex}"
  description = "Amazon EKS - AWS IAM Roles for Service Accounts (IRSA)."

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid    = "STSGrantAssumeRoleWithWebIdentityRights"
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.selected[0].arn
        }
        Condition = {
          StringEquals = {
            # Role scoped to the service account only.
            "${replace(data.aws_iam_openid_connect_provider.selected[0].url, "https://", "")}:sub" = local.dns01_federated_subject
          }
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cert-manager-dns01" {
  count = local.enable_letsencrypt && var.letsencrypt_enable_dns01_challenge ? 1 : 0

  policy_arn = aws_iam_policy.cert-manager-dns01[0].arn
  role       = aws_iam_role.cert-manager-dns01[0].name
}

resource "aws_iam_policy" "cert-manager-dns01" {
  count = local.enable_letsencrypt && var.letsencrypt_enable_dns01_challenge ? 1 : 0

  name        = "cert-manager-dns01-policy-${random_id.cert-manager-dns01[0].hex}"
  path        = "/"
  description = "A policy that allows Cert Manager to create Route53 records for a specific hosted zone."

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect"   = "Allow",
        "Action"   = "route53:GetChange",
        "Resource" = "arn:aws:route53:::change/*"
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Resource" = "arn:aws:route53:::hostedzone/${data.aws_route53_zone.public-zone[0].zone_id}"
      },
    ]
  })

  tags = var.tags
}