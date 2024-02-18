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

resource "random_id" "azwi-test" {
  count = var.deploy_azwi_test ? 1 : 0

  byte_length = 4
}

resource "azurerm_resource_group" "azwi-test" {
  count = var.deploy_azwi_test ? 1 : 0

  name     = "rg-azwi-test-${random_id.azwi-test[0].hex}"
  location = var.azwi_test_location

  tags = var.tags
}

resource "azurerm_key_vault" "azwi-test" {
  count = var.deploy_azwi_test ? 1 : 0

  name                        = "kv-azwi-test-${random_id.azwi-test[0].hex}"
  location                    = azurerm_resource_group.azwi-test[0].location
  resource_group_name         = azurerm_resource_group.azwi-test[0].name
  tenant_id                   = data.azuread_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"

  tags = var.tags
}

# https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli
resource "azurerm_role_assignment" "azwi-test-kv-secrets-officer" {
  count = var.deploy_azwi_test ? 1 : 0

  scope                = azurerm_key_vault.azwi-test[0].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "azwi-test" {
  count = var.deploy_azwi_test ? 1 : 0

  name         = "azwi-test"
  value        = "Hello World!"
  key_vault_id = azurerm_key_vault.azwi-test[0].id

  depends_on = [azurerm_role_assignment.azwi-test-kv-secrets-officer]
}

# https://azure.github.io/azure-workload-identity/docs/quick-start.html#7-deploy-workload
resource "kubernetes_pod_v1" "azwi-test" {
  count = var.deploy_azwi_test ? 1 : 0

  metadata {
    name      = "azwi-test"
    namespace = local.azwi_test_config.namespace_name

    labels = {
      # Represents that this pod will be mutated for workload identity.
      "azure.workload.identity/use" = "true"
    }
  }
  spec {
    service_account_name = local.azwi_test_config.service_account_name
    container {
      image = "ghcr.io/azure/azure-workload-identity/msal-go"
      name  = "oidc"
      env {
        name  = "KEYVAULT_URL"
        value = "${azurerm_key_vault.azwi-test[0].name}.vault.azure.net"
      }
      env {
        name  = "SECRET_NAME"
        value = azurerm_key_vault_secret.azwi-test[0].name
      }
    }
    node_selector = {
      "kubernetes.io/os" = "linux"
    }
  }

  depends_on = [
    azurerm_key_vault_secret.azwi-test,
    azuread_application_federated_identity_credential.this,
    azurerm_role_assignment.this,
    kubernetes_service_account_v1.this,
  ]
}