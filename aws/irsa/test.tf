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

resource "random_id" "irsa-test" {
  count = var.deploy_irsa_test ? 1 : 0

  byte_length = 4
}

resource "aws_s3_bucket" "irsa-test" {
  count = var.deploy_irsa_test ? 1 : 0

  bucket = "irsa-test-${random_id.irsa-test[0].hex}"

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "irsa-test-block-public-access" {
  count = var.deploy_irsa_test ? 1 : 0

  bucket                  = aws_s3_bucket.irsa-test[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "irsa-test-enforce-https-only" {
  count = var.deploy_irsa_test ? 1 : 0

  bucket = aws_s3_bucket.irsa-test[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "S3EnforceHTTPSOnly"
        Effect    = "Deny"
        Action    = "s3:*"
        Principal = "*"
        Resource = [
          aws_s3_bucket.irsa-test[0].arn,
          "${aws_s3_bucket.irsa-test[0].arn}/*",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
    ]
  })
}

resource "aws_s3_object" "irsa-test" {
  count = var.deploy_irsa_test ? 1 : 0

  bucket                 = aws_s3_bucket.irsa-test[0].id
  key                    = "irsa-test.txt"
  content                = local.irsa_test_message
  content_type           = "text/plain"
  server_side_encryption = "AES256"
  # Triggers updates when the value changes like etag but useful to
  # address etag encryption limitations.
  source_hash            = md5(local.irsa_test_message)
}

resource "kubernetes_pod_v1" "irsa-test" {
  count = var.deploy_irsa_test ? 1 : 0

  metadata {
    name      = "irsa-test"
    namespace = local.irsa_test_config.namespace_name
  }
  spec {
    service_account_name = local.irsa_test_config.service_account_name
    restart_policy       = "OnFailure"
    container {
      image   = "amazon/aws-cli"
      name    = "aws-cli-oidc"
      command = ["aws", "s3", "cp", "s3://${aws_s3_bucket.irsa-test[0].id}/${aws_s3_object.irsa-test[0].key}", "-"]
    }
    node_selector = {
      "kubernetes.io/os" = "linux"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.this,
    kubernetes_service_account_v1.this,
  ]
}