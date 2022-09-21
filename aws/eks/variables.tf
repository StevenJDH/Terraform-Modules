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

variable "eks_subnet_configuration" {
  description = "Sets the private and public subnet configuration. Choose the availability zone using letters a to c, mark the subnet as public or not, add a private or public NAT Gateway if needed, and select which subnets will host the EKS worker nodes. The new_bits attribute is the number of additional bits that defines the subnet's IPv4 CIDR block. For more information, see [Amazon EKS VPC and subnet requirements and considerations](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)."
  type        = list(object({
    new_bits                  = number
    availability_zone         = string
    make_public               = bool
    create_nat_gateway        = bool
    allow_worker_nodes        = bool
  }))
  default     = [
    {
      new_bits                  = 8
      availability_zone         = "a"
      make_public               = true
      create_nat_gateway        = true
      allow_worker_nodes        = false
    },
    {
      new_bits                  = 8
      availability_zone         = "a"
      make_public               = false
      create_nat_gateway        = false
      allow_worker_nodes        = true
    },
    {
      new_bits                  = 8
      availability_zone         = "b"
      make_public               = true
      create_nat_gateway        = true
      allow_worker_nodes        = false
    },
    {
      new_bits                  = 8
      availability_zone         = "b"
      make_public               = false
      create_nat_gateway        = false
      allow_worker_nodes        = true
    },
  ]
  validation {
    condition = alltrue(
      [for v in var.eks_subnet_configuration : (contains(["a", "b", "c"], v["availability_zone"]))]
    )
    error_message = "Required availability zone can only be a, b, or c."
  }
  validation {
    condition = length(var.eks_subnet_configuration) >= 2
    error_message = "EKS requires at least 2 subnets across 2 different availability zones."
  }
}

variable "cluster_name" {
  description = "The name of the EKS Cluster to create."
  type        = string
}

variable "kubernetes_version" {
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version at resource creation is used and no upgrades will occur except those automatically triggered by EKS. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS."
  type        = string
  default     = null
}

variable "enable_cluster_log_types" {
  description = "List of the desired control plane logging to enable. For more information, see [Amazon EKS Control Plane Logging](https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)."
  type        = list(string)
  default     = ["api", "audit"]
  validation {
    condition = alltrue(
      [for v in var.enable_cluster_log_types : (contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], v))]
    )
    error_message = "The desired control plane logs can only be api, audit, authenticator, controllerManager, and scheduler."
  }
}

variable "cloudwatch_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 90
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.cloudwatch_log_retention_in_days)
    error_message = "Required CloudWatch log retention in days can only be 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  }
}

variable "worker_nodes_ein_security_group_ids" {
  description = "List of security group IDs for the cross-account supporting elastic network interfaces in the selected subnets that EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane. The VPC's default security group is always included whether additional security groups are provided or not."
  type        = list(string)
  default     = []
}

variable "endpoint_private_access" {
  description = "Indicates whether or not to enable access to the EKS private API server endpoint."
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Indicates whether or not to enable access to the EKS public API server endpoint. If set to true, an Internet Gateway is automatically created, and if false, one is still created if `create_nat_gateway` and `make_public` are true in `eks_subnet_configuration`."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "Public access source whitelist. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from. We recommend that you specify a block that does not overlap with resources in other networks that are peered or connected to your VPC. The block must meet the following requirements: Within one of the following private IP address blocks: 10.0.0.0/8, 172.16.0.0/12, or 192.168.0.0/16, doesn't overlap with any CIDR block assigned to the VPC that you selected for VPC, and between /24 and /12."
  type        = string
  default     = "10.100.0.0/16"
}

variable "eks_node_group_config" {
  description = "Sets the EKS Node Group configuration, which can provision and optionally update an Auto Scaling Group of Kubernetes worker nodes compatible with EKS."
  type        = list(object({
    prefix                 = optional(string)
    instance_type          = string
    capacity_type          = string
    disk_size              = number
    labels                 = map(string)
    scaling_desired_size   = number
    scaling_max_size       = number
    scaling_min_size       = number
    taints                 = list(object({
      key    = string
      value  = string
      effect = string
    }))
    update_max_unavailable = optional(number)
    update_max_unavailable_percentage = optional(number)
  }))
  default     = [
    {
      prefix                 = "minion-"
      instance_type          = "t3.medium"
      capacity_type          = "ON_DEMAND"
      disk_size              = 20
      labels                 = null
      scaling_desired_size   = 2
      scaling_max_size       = 2
      scaling_min_size       = 2
      taints                 = []
      update_max_unavailable = 1
      update_max_unavailable_percentage = null
    },
  ]
}

variable "eks_cluster_addons" {
  description = "Installs the default EKS add-ons, which can overridden. If a version is not provided, the latest default version will be used. For more information, see [Amazon EKS add-ons](https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html)."
  type        = list(object({
    name    = string
    version = optional(string)
  }))
  default     = [
    {
      name    = "kube-proxy"
      version = null
    },
    {
      name    = "vpc-cni"
      version = null
    },
    {
      name    = "coredns"
      version = null
    },
  ]
}

variable "fargate_namespaces" {
  description = "List of dedicated namespaces that will run Pods on Fargate serverless nodes, but the actual namespaces in the cluster will still need to be created. If the `kube-system` namespace is added, coredns will be patched (ec2 annotation removed) to run on it. Containers running in a Fargate namespace can't assume the IAM permissions associated with a Pod execution role. To give these containers permissions to access other AWS services, deploy the [AWS IRSA (IAM Roles for Service Accounts) module](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa)."
  type        = set(string)
  default     = []
}

variable "enable_fargate_only" {
  description = "Indicates whether or not to configure the cluster to only have Fargate serverless nodes. As part of this, `kube-system` and `default` namespaces will be included automatically as Fargate namespaces. Containers running in this mode can't assume the IAM permissions associated with a Pod execution role. To give these containers permissions to access other AWS services, deploy the [AWS IRSA (IAM Roles for Service Accounts) module](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa)."
  type        = bool
  default     = false
}

variable "enable_node_ssh_access" {
  description = "Indicates whether or not to provide access for SSH communication with the worker nodes in the EKS Node Groups. If set to true, ensure that the Terraform state file is stored on encrypted storage like an AWS S3 bucket with SSE-S3 enabled to better protect the SSH key in the state file."
  type        = bool
  default     = false
}

variable "enable_ssh_access_from_internet" {
  description = "Indicates whether or not to open port 22 on the worker nodes to the Internet (0.0.0.0/0). This option is only meant for testing. Setting to it to false will automatically associate the VPC's default security group."
  type        = bool
  default     = false
}

variable "ssh_key_pair_rsa_bits" {
  description = "The size of the generated RSA key pair in bits for SSH."
  type        = number
  default     = 4096
}

variable "save_ssh_key_pair_locally" {
  description = "Indicates whether or not to save the generated SSH key pair locally. If this file is removed, or a plan is done from a new machine for automation, Terraform will generate a diff to re-create it. This may cause unwanted noise in a plan. Alternatively, use `save_ssh_key_pair_remotely` instead to mitigate this issue."
  type        = bool
  default     = true
}

variable "save_ssh_key_pair_remotely" {
  description = "Indicates whether or not to save the generated SSH key pair remotely to a pre-created S3 bucket. If set to true, `ssh_key_bucket_name` is required."
  type        = bool
  default     = false
}

variable "ssh_key_bucket_name" {
  description = "Name of the bucket to save the SSH key pair file to. Requires `save_ssh_key_pair_remotely` to be set to true. The SSH key pair file will be stored with AWS AES256 managed server-side encryption (SSE-S3) in the defined bucket."
  type        = string
  default     = null
}

variable "ssh_key_bucket_file_key_prefix" {
  description = "The key prefix for the SSH key pair file to nest within a folder like structure. For example, `/backup/` or `backup/`, with or without the leading slash, will save the SSH key pair file as `backup/my-ssh.key`. Requires `save_ssh_key_pair_remotely` to be set to true."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}

variable "vpc_tags" {
  description = "Additional tags for the VPC."
  type        = map(string)
  default     = null
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets."
  type        = map(string)
  default     = null
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets."
  type        = map(string)
  default     = null
}

variable "eks_tags" {
  description = "Additional tags for EKS."
  type        = map(string)
  default     = null
}

variable "eks_node_group_tags" {
  description = "Additional tags for EKS Node Groups."
  type        = map(string)
  default     = null
}