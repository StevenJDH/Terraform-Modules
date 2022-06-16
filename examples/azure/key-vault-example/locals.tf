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

  access_policies = {
    (data.azurerm_client_config.current.object_id) = {
      certificate_permissions = ["List", "Get"]
      key_permissions         = ["List", "Get"]
      secret_permissions      = ["List", "Get", "Delete", "Recover", "Set", "Purge", "Restore"]
      storage_permissions     = ["List", "Get"]
    },
  }

  network_acls = {
    bypass_network_acls           = true
    allow_when_no_acl_rules_match = false
    ip_rules                      = []
    virtual_network_subnet_ids    = []
  }

  tags = {
    environment = local.stage
    terraform   = true
  }
}