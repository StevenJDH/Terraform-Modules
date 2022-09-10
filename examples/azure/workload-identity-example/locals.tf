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
  stage = "dev"

  azwi_application_config = [
    {
      application_name       = "azwi-example-app-${local.stage}"
      namespace_name         = kubernetes_namespace_v1.azwi-example.metadata[0].name
      create_service_account = true
      service_account_name   = "azwi-example-sa"
      roles                  = [
        {
          scope     = data.azurerm_subscription.primary.id # Reduce role scope for actual use.
          role_name = "Key Vault Secrets User"
        },
      ]
    },
  ]

  tags = {
    environment = local.stage
    terraform   = true
  }
}