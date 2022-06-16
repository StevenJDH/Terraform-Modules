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

data "azurerm_client_config" "current" {}

# Make sure the vnet has Microsoft.KeyVault in Service Endpoints configured.
data "azurerm_virtual_network" "example" {
  name                = "vnet_private_network_example_dev"
  resource_group_name = "rg_private_network_example_dev"
}

data "azurerm_subnet" "example" {
  name                 = "snet_private_network_example_dev"
  resource_group_name  = data.azurerm_virtual_network.example.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.example.name
}