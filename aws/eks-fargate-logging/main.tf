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

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = "aws-observability"
    labels = {
      aws-observability = "enabled"
    }
  }
}

resource "aws_eks_fargate_profile" "this" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "fargate-profile-${kubernetes_namespace_v1.this.metadata[0].name}"
  pod_execution_role_arn = data.aws_iam_role.selected.arn
  subnet_ids             = var.private_fargate_worker_node_subnet_ids # Only private subnets are supported.

  selector {
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.fargate-cwl-for-fluent-bit
  ]
}

resource "kubernetes_config_map_v1" "fargate-cwl-for-fluent-bit" {
  metadata {
    name      = "aws-logging"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  data = {
    flb_log_cw     = "true" # Ships fluent-bit process logs to CloudWatch.
    "filters.conf" = <<EOF
[FILTER]
    Name parser
    Match *
    Key_name log
    Parser crio
[FILTER]
    Name kubernetes
    Match kube.*
    Merge_Log On
    Keep_Log Off
    Buffer_Size 0
    Kube_Meta_Cache_TTL 300s
EOF
    # This uses the newer Fluent Bit CloudWatch plugin written in C called "cloudwatch_logs", which
    # offers more performance than the older Fluent Bit Plugin for CloudWatch Logs written in Golang
    # called "cloudwatch." Templates have precedence over fallback log_group_name and log_stream_prefix.
    # NOTE: Naming conventions for log groups and log streams can only use dots and commas.
    "output.conf"  = <<EOF
[OUTPUT]
    Name cloudwatch_logs
    Match kube.*
    region ${var.region}
    log_group_name fluent-bit-cloudwatch-${var.cluster_name}
    log_stream_prefix from-fluent-bit-
    log_retention_days ${var.cloudwatch_log_retention_in_days}
    auto_create_group true
    log_group_template ${var.cluster_name}.$kubernetes['namespace_name'].$kubernetes['pod_name']
    log_stream_template $kubernetes['container_name'].container
EOF
    "parsers.conf" = <<EOF
[PARSER]
    Name crio
    Format Regex
    Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>P|F) (?<log>.*)$
    Time_Key time
    Time_Format %Y-%m-%dT%H:%M:%S.%L%z
EOF
  }
}

resource "aws_iam_policy" "fargate-cwl-for-fluent-bit" {
  name        = "AmazonFargateCloudWatchLogsForFluentBit-${var.cluster_name}"
  path        = "/"
  description = "Provides access to the Fluent Bit output plugin for CloudWatch Logs on Fargate."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:putRetentionPolicy"
        ]
        Resource = "*"
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "fargate-cwl-for-fluent-bit" {
  policy_arn = aws_iam_policy.fargate-cwl-for-fluent-bit.arn
  role       = var.eks_fargate_role_name
}