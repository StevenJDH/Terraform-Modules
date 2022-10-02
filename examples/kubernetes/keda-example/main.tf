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

module "keda-on-k8s" {
  source = "../../../kubernetes/keda"

  keda_version          = local.keda_version
  create_keda_namespace = true
}

module "keda-on-aws-eks" {
  source = "../../../kubernetes/keda"
  # Only used to avoid config conflict with other examples.
  providers = {
    kubernetes = kubernetes.aws
    helm       = helm.aws
  }

  keda_version          = local.keda_version
  create_keda_namespace = true
  enable_irsa           = true
  irsa_role_arn         = "arn:aws:iam::000000000000:role/example-irsa-role"
}

module "keda-on-azure-aks" {
  source = "../../../kubernetes/keda"
  # Only used to avoid config conflict with other examples.
  providers = {
    kubernetes = kubernetes.azure
    helm       = helm.azure
  }

  keda_version          = local.keda_version
  create_keda_namespace = true
  enable_azwi_system    = true
  azwi_client_id        = "9ec033ad-d050-416f-b376-09a3527d5edb"
}