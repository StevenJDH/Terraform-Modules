/*
 * This file is part of Terraform-Modules <https://github.com/StevenJDH/Terraform-Modules>.
 * Copyright (C) 2024 Steven Jenkins De Haro.
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

module "sp-example" {
  source = "../../../azure/service-principal"

  service_principal_name      = "my-sp-example-${local.stage}"
  role_definition_name        = "Contributor"
  scope                       = data.azurerm_subscription.primary.id
  client_secret_rotation_days = 730
  owners                      = [data.azurerm_client_config.current.object_id]
}

module "custom-sp-example" {
  source = "../../../azure/service-principal"

  service_principal_name        = "my-custom-sp-example-${local.stage}"
  role_definition_name          = "Example"
  scope                         = data.azurerm_subscription.primary.id
  client_secret_rotation_days   = 365
  owners                        = [data.azurerm_client_config.current.object_id]

  create_custom_role_definition = true
  custom_role_description       = "This is a custom example."
  custom_role_actions           = ["Microsoft.Storage/storageAccounts/read"]
  custom_role_data_actions      = ["*"]
  custom_role_assignable_scopes = [data.azurerm_subscription.primary.id]
}