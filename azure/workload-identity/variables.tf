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

variable "deploy_azwi_system" {
  description = "Deploy the Azure AD Workload Identity system. See [AZWI Introduction](https://github.com/Azure/azure-workload-identity/blob/main/docs/book/src/introduction.md) for more information"
  type        = bool
  default     = false
}

variable "azwi_version" {
  description = "Version of Workload Identity system to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "azwi_application_config" {
  description = "Sets the azwi application configuration, which manages app registrations, azwi service accounts, roles, etc. Default azwi service account token expiration is \"86400\" (1 day) unless specified differently in seconds. If the azwi service account will be created by a helm project, set `create_service_account` to `false`, and ensure the defined namespace is used. For more info, see `Labels and Annotations` [[here](https://azure.github.io/azure-workload-identity/docs/topics/service-account-labels-and-annotations.html)] or [[here](https://github.com/Azure/azure-workload-identity/blob/main/docs/book/src/topics/service-account-labels-and-annotations.md)]."
  type        = list(object({
    application_name          = string
    namespace_name            = string
    create_service_account    = bool
    service_account_name      = string
    service_account_token_exp = optional(string)
    roles                     = optional(list(object({
      scope     = string
      role_name = string
    })))
  }))

  default = []
}

variable "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster."
  type        = string
}

variable "deploy_azwi_test" {
  description = "Deploys test resources to validate if the azwi setup is working using the Microsoft Authentication Library (MSAL). When done, make sure to set `deploy_azwi_test` to `false` to cleanup the test resources and avoid additional costs."
  type        = bool
  default     = false
}

variable "azwi_test_location" {
  description = "Azure location for azwi test resources."
  type        = string
  default     = "West Europe"
}

variable "tags" {
  description = "Resource tags for test resources only."
  type        = map(string)
  default     = null
}