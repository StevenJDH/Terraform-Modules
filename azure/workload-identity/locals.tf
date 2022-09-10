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

locals {
  azwi_test_config = {
    application_name          = "azwi-test-app"
    namespace_name            = "default"
    create_service_account    = true
    service_account_name      = "azwi-test-sa"
    service_account_token_exp = "86400"
    roles                  = [
      {
        scope     = var.deploy_azwi_test ? azurerm_key_vault.azwi-test[0].id : null # Avoids conflict on delete.
        role_name = "Key Vault Secrets User"
      },
    ]
  }

  azwi_app_config = var.deploy_azwi_test ? concat(var.azwi_application_config, [local.azwi_test_config]) : var.azwi_application_config

  federated_subjects = [
    for v in local.azwi_app_config : format("system:serviceaccount:%s:%s", v.namespace_name, v.service_account_name)
  ]

  service_accounts = tomap({
    for k, v in local.azwi_app_config : k => v if v.create_service_account
  })

  app_roles = flatten([
    for k, v in local.azwi_app_config : [
      for role in v.roles : {
        key       = k
        role_name = role.role_name
        scope     = role.scope
      }
    ]
  ])
}