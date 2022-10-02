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

provider "kubernetes" {
  config_path    = local.config_path
  config_context = local.config_context
  insecure       = true
}

provider "helm" {
  kubernetes {
    config_path    = local.config_path
    config_context = local.config_context
    insecure       = true
  }
}

provider "kubernetes" {
  alias = "aws"
  host                   = data.aws_eks_cluster.selected.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority.0.data)
  # Alternative to exec approach to avoid needing local CLI.
  token                  = data.aws_eks_cluster_auth.current.token
}

provider "helm" {
  alias = "aws"
  kubernetes {
    host                   = data.aws_eks_cluster.selected.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.selected.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.current.token
  }
}

provider "kubernetes" {
  alias = "azure"
  host                   = data.azurerm_kubernetes_cluster.selected.kube_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.selected.kube_config.0.cluster_ca_certificate)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.selected.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.selected.kube_config.0.client_key)
}

provider "helm" {
  alias = "azure"
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.selected.kube_config.0.host
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.selected.kube_config.0.cluster_ca_certificate)
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.selected.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.selected.kube_config.0.client_key)
  }
}

provider "azurerm" {
  features {}
}