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

resource "azurerm_role_definition" "this" {
  count = var.create_custom_role_definition ? 1 : 0

  name              = "${var.role_definition_name}-custom-role"
  scope             = var.scope
  description       = var.custom_role_description
  assignable_scopes = var.custom_role_assignable_scopes

  permissions {
    actions          = var.custom_role_actions
    not_actions      = var.custom_role_not_actions
    data_actions     = var.custom_role_data_actions
    not_data_actions = var.custom_role_not_data_actions
  }
}

resource "azuread_application" "this" {
  display_name = var.service_principal_name
  owners       = var.owners
}

resource "time_rotating" "this" {
  rotation_days = var.client_secret_rotation_days
}

resource "azuread_application_password" "this" {
  application_id = azuread_application.this.id
  display_name   = "TF Managed. Renews: ${time_rotating.this.rotation_rfc3339}"

  rotate_when_changed = {
    rotation = time_rotating.this.id
  }
}

resource "azuread_service_principal" "this" {
  client_id                    = azuread_application.this.client_id
  owners                       = var.owners
}

resource "azurerm_role_assignment" "this" {
  principal_id         = azuread_service_principal.this.object_id
  scope                = var.scope
  role_definition_id   = var.create_custom_role_definition ? azurerm_role_definition.this[0].role_definition_resource_id : null
  role_definition_name = var.create_custom_role_definition == false ? var.role_definition_name : null
}