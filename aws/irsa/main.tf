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

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = [local.oidc_audience]
  thumbprint_list = [data.tls_certificate.oidc-issuer.certificates[0].sha1_fingerprint]
  url             = var.oidc_issuer_url

  tags = merge(
    { Name = "oidc-irsa-${var.eks_cluster_name}" },
    var.tags
  )
}

resource "aws_iam_role" "this" {
  count = length(local.irsa_app_config)

  name        = "irsa-role-${local.irsa_app_config[count.index].application_name}"
  description = "Amazon EKS - AWS IAM Roles for Service Accounts (IRSA)."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "STSGrantAssumeRoleWithWebIdentityRights"
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.this.arn
        }
        Condition = {
          StringEquals = {
            # Role scoped to the service account only.
            "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub" = element(local.federated_subjects, count.index)
          }
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(local.policy_arns)

  policy_arn = local.policy_arns[count.index].policy_arn
  role       = aws_iam_role.this[local.policy_arns[count.index].key].name
}

# This should ideally be created by the application helm project.
resource "kubernetes_service_account_v1" "this" {
  for_each = local.service_accounts

  metadata {
    name        = each.value.service_account_name
    namespace   = each.value.namespace_name
    annotations = {
      "eks.amazonaws.com/audience"               = local.oidc_audience
      "eks.amazonaws.com/role-arn"               = aws_iam_role.this[each.key].arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true" # Recommended to use regional endpoint in almost all cases.
      "eks.amazonaws.com/token-expiration"       = each.value.service_account_token_exp
    }
  }
}