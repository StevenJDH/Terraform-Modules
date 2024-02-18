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
  count = var.deploy_azwi_system ? 1 : 0

  metadata {
    name = "azure-workload-identity-system"

    annotations = {
      name = "azure-workload-identity-system"
    }
  }
}

resource "helm_release" "azure-workload-identity-system" {
  count = var.deploy_azwi_system ? 1 : 0

  name       = "workload-identity-webhook"
  # Unless the A in Azure.github.io is capitalized, it won't find the chart.
  repository = "https://Azure.github.io/azure-workload-identity/charts"
  chart      = "workload-identity-webhook"
  version    = var.azwi_version == "latest" ? null : var.azwi_version
  namespace  = kubernetes_namespace_v1.this[0].metadata[0].name
  atomic     = true

  set {
    name  = "azureTenantID"
    value = data.azuread_client_config.current.tenant_id
  }
}

# Azure AD application that represents the app.
resource "azuread_application" "this" {
  count = length(local.azwi_app_config)

  display_name = local.azwi_app_config[count.index].application_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "this" {
  count = length(local.azwi_app_config)

  application_id = azuread_application.this[count.index].application_id
  owners         = [data.azuread_client_config.current.object_id]
}

# Azure AD federated identity used to federate kubernetes with Azure AD.
resource "azuread_application_federated_identity_credential" "this" {
  count = length(local.azwi_app_config)

  application_object_id = azuread_application.this[count.index].object_id
  display_name          = local.azwi_app_config[count.index].application_name
  description           = "The federated identity used to federate K8s with Azure AD and the app running in k8s."
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = var.oidc_issuer_url
  # Should match azwi service account namespace and name, which is where app is located.
  subject               = element(local.federated_subjects, count.index)
}

# App role assignment.
resource "azurerm_role_assignment" "this" {
  count = length(local.app_roles)

  scope                = local.app_roles[count.index].scope
  role_definition_name = local.app_roles[count.index].role_name
  principal_id         = azuread_service_principal.this[local.app_roles[count.index].key].object_id
}

# This should ideally be created by the application helm project.
resource "kubernetes_service_account_v1" "this" {
  for_each = local.service_accounts

  metadata {
    name      = each.value.service_account_name
    namespace = each.value.namespace_name

    annotations = {
      "azure.workload.identity/client-id"                        = azuread_application.this[each.key].application_id
      "azure.workload.identity/service-account-token-expiration" = each.value.service_account_token_exp
    }
  }
}