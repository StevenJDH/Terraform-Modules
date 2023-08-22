/*
 * This file is part of Terraform-Modules <https://github.com/StevenJDH/Terraform-Modules>.
 * Copyright (C) 2022-2023 Steven Jenkins De Haro.
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

resource "random_id" "suffix" {
  count = var.add_random_suffix ? 1 : 0

  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket = var.add_random_suffix ? "${var.bucket_name}-${random_id.suffix[0].hex}" : var.bucket_name

  tags = var.tags
}

# Starting in April 2023, Amazon S3 has introduced two new default bucket
# security settings by automatically enabling S3 Block Public Access and
# disabling S3 access control lists (ACLs) for all new S3 buckets.
# References:
# https://aws.amazon.com/about-aws/whats-new/2022/12/amazon-s3-automatically-enable-block-public-access-disable-access-control-lists-buckets-april-2023/
# https://github.com/hashicorp/terraform-provider-aws/issues/28353
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this,
  ]
}

# Trick used for aws_s3_bucket_acl.this resource.
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(var.block_public_policy == false && var.restrict_public_buckets == false && length(var.additional_resource_policy_statements) > 0 ? [] : [
      {
        Sid       = "S3EnforceHTTPSOnly"
        Effect    = "Deny"
        Action    = "s3:*"
        Principal = "*"
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
    ], var.additional_resource_policy_statements)
  })

  # Needed to avoid a 403 error.
  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aes256" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.enable_versioning ? 1 : 0

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = tomap({
      for k, v in var.lifecycle_rules : k => v
    })
    content {
      id = rule.value.rule_name

      dynamic "expiration" {
        for_each = rule.value.expiration_days > 0 || rule.value.version_expiration_days > 0 ? [true] : []
        content {
          days                         = rule.value.expiration_days
          expired_object_delete_marker = rule.value.expiration_days <=0 && rule.value.version_expiration_days > 0 ? true : false
        }
      }

      dynamic "transition" {
        for_each = tomap({
          for k, v in rule.value.transition : k => v
        })
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "filter" {
        for_each = rule.value.filter_prefix != null && rule.value.filter_prefix != "" && rule.value.filter_tags == null && rule.value.filter_size_lt_bytes == null && rule.value.filter_size_gt_bytes == null ? [true] : []
        content {
          prefix = rule.value.filter_prefix
        }
      }

      # AWS doesn't allow using the below when only prefix is provided, but for the others it does.
      dynamic "filter" {
        for_each = rule.value.filter_tags != null || rule.value.filter_size_lt_bytes != null || rule.value.filter_size_gt_bytes != null ? [true] : []
        content {
          and {
            prefix                   = rule.value.filter_prefix != null ? rule.value.filter_prefix : ""
            object_size_less_than    = rule.value.filter_size_lt_bytes
            object_size_greater_than = rule.value.filter_size_gt_bytes
            tags                     = rule.value.filter_tags
          }
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.version_expiration_days > 0 ? [true] : []
        content {
          noncurrent_days = rule.value.version_expiration_days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = tomap({
          for k, v in rule.value.version_transition : k => v
        })
        iterator = version_transition
        content {
          noncurrent_days = version_transition.value.noncurrent_days
          storage_class   = version_transition.value.storage_class
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.delete_incomplete_mp_upload_days > 0 ? [true] : []
        content {
          days_after_initiation = rule.value.delete_incomplete_mp_upload_days
        }
      }

      status = rule.value.enable_rule ? "Enabled" : "Disabled"
    }
  }
}