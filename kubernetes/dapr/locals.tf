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
  dapr_system_namespace     = var.create_dapr_system_namespace ? kubernetes_namespace.dapr-system[0].metadata[0].name : var.dapr_system_namespace
  dapr_apps_namespace       = var.create_dapr_apps_namespace ? kubernetes_namespace.dapr-apps[0].metadata[0].name : var.dapr_apps_namespace
  dapr_monitoring_namespace = var.create_dapr_monitoring_namespace ? kubernetes_namespace.dapr-monitoring[0].metadata[0].name : var.dapr_monitoring_namespace
}