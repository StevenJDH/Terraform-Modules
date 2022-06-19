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

module "public_cognitive_tts" {
  source = "../../../azure/cognitive"

  name                  = "cog-public-tts-example-${local.stage}"
  create_resource_group = true
  resource_group_name   = "rg-public-cognitive-example-${local.stage}"
  location              = var.location
  kind                  = "SpeechServices"
  sku_name              = "F0"

  tags = local.tags
}

module "private_cognitive_tts" {
  source = "../../../azure/cognitive"

  name                  = "cog-private-tts-example-${local.stage}"
  create_resource_group = true
  resource_group_name   = "rg-private-cognitive-example-${local.stage}"
  location              = var.location
  kind                  = "SpeechServices"
  sku_name              = "F0"

  network_acls                             = local.network_acls
  enable_public_or_selected_network_access = true
  custom_subdomain_name                    = "demo-acs"
  create_private_endpoint                  = true

  tags = local.tags
}
