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

resource "kubernetes_namespace_v1" "azwi-example" {
  metadata {
    name   = "azwi-example"
  }
}

module "workload-identity" {
  source = "../../../azure/workload-identity"

  azwi_version            = "1.2.0"
  deploy_azwi_system      = true
  deploy_azwi_test        = true
  azwi_test_location      = var.location
  oidc_issuer_url         = data.azurerm_kubernetes_cluster.selected.oidc_issuer_url
  azwi_application_config = local.azwi_application_config

  tags = local.tags

  depends_on = [
    kubernetes_namespace_v1.azwi-example,
  ]
}