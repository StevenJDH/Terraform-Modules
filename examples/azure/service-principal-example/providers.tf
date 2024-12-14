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

provider "azurerm" {
  # When using the azurerm v4+ provider, specifying subscription id is now mandatory.
  # Set property or the ARM_SUBSCRIPTION_ID environment variable to provide it.
  # Reference: https://registry.terraform.io/providers/hashicorp/azurerm/4.0.0/docs/guides/4.0-upgrade-guide#specifying-subscription-id-is-now-mandatory
  #subscription_id = "00000000-0000-0000-0000-000000000000"

  # One of five options are now required to be set.
  # Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide#improved-resource-provider-registration
  resource_provider_registrations = "none"
  features {}
}

provider "azuread" {
}

provider "time" {
}