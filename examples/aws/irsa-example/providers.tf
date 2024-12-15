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

provider "aws" {
  region  = var.region
  profile = local.aws_profile
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.selected.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority.0.data)

  # Alternative to exec when no local CLI, "token = data.aws_eks_cluster_auth.cluster.token".
  exec {
    # Requires aws-cli/2.7+ or use v1alpha1. Verify with "aws eks get-token --cluster-name $NAME | jq '.apiVersion'"
    # Reference: https://github.com/hashicorp/terraform-provider-helm/issues/893#issuecomment-1159334286
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.selected.name, "--region", var.region]
    command     = "aws"
    env = {
      AWS_PROFILE = local.aws_profile
    }
  }
}

provider "tls" {}

provider "random" {}