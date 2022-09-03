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

module "vpc-eks" {
  source = "../vpc"

  name                                = var.cluster_name
  enable_dns_support                  = true
  enable_dns_hostnames                = true
  enable_ipv6                         = false
  create_egress_only_internet_gateway = false
  create_internet_gateway             = var.endpoint_public_access
  subnet_configuration                = local.subnet_configuration
  single_private_route_table          = false
  # Forces each AZ to have it's own public route table
  # configuration for the EKS 2 or more AZ requirement.
  single_public_route_table           = false

  tags                = var.tags
  private_subnet_tags = local.subnet_tags
  public_subnet_tags  = local.subnet_tags
}

resource "aws_eks_cluster" "this" {
  name                      = "eks-${var.cluster_name}"
  role_arn                  = aws_iam_role.eks-cluster.arn
  version                   = var.kubernetes_version
  enabled_cluster_log_types = var.enable_cluster_log_types
  
  vpc_config {
    subnet_ids              = local.worker_nodes_subnet_ids
    security_group_ids      = concat([module.vpc-eks.vpc_default_security_group_id], var.worker_nodes_ein_security_group_ids)
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }
  
  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
    ip_family         = "ipv4"
  }

  tags = merge(
    { Name = "eks-${var.cluster_name}" },
    var.tags,
    var.eks_tags,
  )

  # Ensures that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    module.vpc-eks,
    aws_iam_role_policy_attachment.eks-cluster-policy,
    aws_iam_role_policy_attachment.eks-vpc-resource-controller,
    aws_cloudwatch_log_group.this,
  ]
}

resource "aws_eks_addon" "this" {
  for_each  = tomap({
    for addon in var.eks_cluster_addons : addon.name => addon
  })

  cluster_name      = aws_eks_cluster.this.id
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_node_group" "this" {
  count = length(var.eks_node_group_config)

  cluster_name           = aws_eks_cluster.this.name
  node_group_name_prefix = var.eks_node_group_config[count.index].prefix != null ? var.eks_node_group_config[count.index].prefix : "minion-"
  node_role_arn          = aws_iam_role.eks-node.arn
  subnet_ids             = local.worker_nodes_subnet_ids
  instance_types         = [var.eks_node_group_config[count.index].instance_type]
  capacity_type          = var.eks_node_group_config[count.index].capacity_type
  disk_size              = var.eks_node_group_config[count.index].disk_size
  labels                 = var.eks_node_group_config[count.index].labels

  scaling_config {
    desired_size = var.eks_node_group_config[count.index].scaling_desired_size
    max_size     = var.eks_node_group_config[count.index].scaling_max_size
    min_size     = var.eks_node_group_config[count.index].scaling_min_size
  }

  dynamic "taint" {
    for_each = tomap({
      for v in var.eks_node_group_config[count.index].taints : v.key => v
    })

    content {
      key    = taint.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  update_config {
    max_unavailable             = var.eks_node_group_config[count.index].update_max_unavailable
    max_unavailable_percentage  = var.eks_node_group_config[count.index].update_max_unavailable_percentage
  }

  dynamic "remote_access" {
    for_each = var.enable_node_ssh_access ? [true] : []

    content {
      ec2_ssh_key               = aws_key_pair.this[0].key_name
      source_security_group_ids = var.enable_ssh_access_from_internet ? [] : [module.vpc-eks.vpc_default_security_group_id]
    }
  }

  lifecycle {
    ignore_changes = [scaling_config.0.desired_size]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-node-policy,
    aws_iam_role_policy_attachment.ec2-container-registry-read-only,
    aws_iam_role_policy_attachment.eks-cni-policy,
  ]

  tags = merge(
    var.tags,
    var.eks_node_group_tags,
  )
}

resource "tls_private_key" "ssh" {
  count = var.enable_node_ssh_access ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = var.ssh_key_pair_rsa_bits
}

resource "aws_key_pair" "this" {
  count = var.enable_node_ssh_access ? 1 : 0

  key_name   = "${var.cluster_name}-keypair"
  public_key = tls_private_key.ssh[0].public_key_openssh

  tags = var.tags
}

resource "local_sensitive_file" "ssh-key-pair" {
  count = var.enable_node_ssh_access && var.save_ssh_key_pair_locally ? 1 : 0

  content         =  tls_private_key.ssh[0].private_key_pem
  filename        =  "${path.cwd}/${aws_key_pair.this[0].key_name}.pem"
  file_permission = "0700"
}

resource "aws_s3_object" "ssh-key-pair" {
  count = var.enable_node_ssh_access && var.save_ssh_key_pair_remotely ? 1 : 0

  bucket                 = var.ssh_key_bucket_name
  key                    = "${var.ssh_key_bucket_file_key_prefix}${aws_key_pair.this[0].key_name}.pem"
  content                = tls_private_key.ssh[0].private_key_pem
  content_type           = "application/x-pem-file"
  server_side_encryption = "AES256"
  # Triggers updates when the value changes like etag but useful to 
  # address etag encryption limitations.
  source_hash            = md5(tls_private_key.ssh[0].private_key_pem)
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/eks-${var.cluster_name}/cluster"
  retention_in_days = var.cloudwatch_log_retention_in_days

  tags = var.tags
}

resource "aws_iam_role" "eks-node" {
  name        = "eks-node-role-${var.cluster_name}"
  description = "Amazon EKS - Node role."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2GrantAssumeRoleRights"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
  # This policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "ec2-container-registry-read-only" {
  # Provides read-only access to Amazon EC2 Container Registry repositories.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-cni-policy" {
  # This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it
  # requires to modify the IP address configuration on your EKS worker nodes. This
  # permission set allows the CNI to list, describe, and modify Elastic Network Interfaces
  # on your behalf.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role" "eks-cluster" {
  name        = "eks-cluster-role-${var.cluster_name}"
  description = "Amazon EKS - Cluster role."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EKSGrantAssumeRoleRights"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  # This policy provides Kubernetes the permissions it requires to manage resources on
  # your behalf. Kubernetes requires Ec2:CreateTags permissions to place identifying
  # information on EC2 resources including but not limited to Instances, Security
  # Groups, and Elastic Network Interfaces.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-vpc-resource-controller" {
  # Policy used by VPC Resource Controller to manage ENI and IPs for worker nodes.
  # Enables Security Groups for Pods. Most Nitro-based Amazon EC2 instance families,
  # including the m5, c5, r5, p3, m6g, c6g, and r6g instance families. The t3 instance
  # family is not supported by Security Groups for Pods.
  # https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster.name
}