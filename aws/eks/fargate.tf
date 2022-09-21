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

resource "aws_eks_fargate_profile" "this" {
  for_each = local.fargate_namespaces

  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "fargate-profile-${each.value}"
  pod_execution_role_arn = aws_iam_role.eks-fargate[0].arn
  subnet_ids             = local.fargate_worker_nodes_subnet_ids # Only private subnets are supported.

  selector {
    namespace = each.value
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks-fargate-pod-execution-role-policy
  ]
}

resource "aws_iam_role" "eks-fargate" {
  count = length(local.fargate_namespaces) > 0 ? 1 : 0

  name        = "eks-fargate-role-${var.cluster_name}"
  description = "Amazon EKS - Fargate role."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "FargateGrantAssumeRoleRights"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks-fargate-pod-execution-role-policy" {
  count = length(local.fargate_namespaces) > 0 ? 1 : 0

  # Provides access to other AWS service resources that are required to
  # run Amazon EKS pods on AWS Fargate.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks-fargate[0].name
}

resource "local_file" "fargate-coredns-patch-ca" {
  count = local.apply_fargate_coredns_patch ? 1 : 0

  content         = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  filename        = "ca.crt"
  file_permission = "0777"
}

resource "local_file" "fargate-coredns-patch-json" {
  count = local.apply_fargate_coredns_patch ? 1 : 0

  filename        = "fargate-coredns-patch.json"
  file_permission = "0777"

  content = jsonencode([
    {
      op   = "remove"
      path = "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"
    }
  ])
}

resource "null_resource" "fargate-coredns-patch" {
  count = local.apply_fargate_coredns_patch ? 1 : 0

  triggers = {
    endpoint = aws_eks_cluster.this.endpoint
    ca_crt   = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    token    = data.aws_eks_cluster_auth.current[0].token
  }

  provisioner "local-exec" {
    # Patch only needed when there are managed node groups and a Fargate profile for the kube-system namespace.
    # Took this approach in conjunction with the local_file resource to support patching from Windows, Linux, macOS.
    # Reference: https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html#fargate-gs-coredns
    command = "kubectl patch deployment coredns -n kube-system --type json --patch-file fargate-coredns-patch.json --server=${aws_eks_cluster.this.endpoint} --certificate_authority=ca.crt --token=${data.aws_eks_cluster_auth.current[0].token}"
  }

  lifecycle {
    ignore_changes = [triggers]
  }

  depends_on = [
    aws_eks_fargate_profile.this,
    local_file.fargate-coredns-patch-ca,
    local_file.fargate-coredns-patch-json,
  ]
}