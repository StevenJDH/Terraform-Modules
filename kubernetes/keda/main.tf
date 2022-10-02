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

resource "kubernetes_namespace_v1" "keda" {
  count = var.create_keda_namespace ? 1 : 0

  metadata {
    name = var.keda_namespace
  }
}

# https://github.com/kedacore/charts/blob/main/keda/values.yaml
resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = var.keda_version == "latest" ? null : var.keda_version
  namespace  = local.keda_namespace
  atomic     = true

  set {
    name  = "volumes.metricsApiServer.extraVolumes[0].name"
    value = "keda-volume"
  }

  set {
    name  = "volumes.metricsApiServer.extraVolumeMounts[0].name"
    value = "keda-volume"
  }

  set {
    name  = "volumes.metricsApiServer.extraVolumeMounts[0].mountPath"
    value = "/apiserver.local.config/certificates/"
  }

  set {
    name  = "securityContext.metricServer.readOnlyRootFilesystem"
    value = true
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "podIdentity.azureWorkload.enabled"
    value = local.enable_azwi_system
  }

  dynamic "set" {
    for_each = local.enable_azwi_system ? [true] : []
    content {
      name  = "podIdentity.azureWorkload.clientId"
      value = var.azwi_client_id
    }
  }

  dynamic "set" {
    for_each = local.enable_azwi_system ? [true] : []
    content {
      name  = "podIdentity.azureWorkload.tenantId"
      value = data.azurerm_client_config.current[0].tenant_id
    }
  }

  dynamic "set" {
    for_each = local.enable_azwi_system ? [true] : []
    content {
      name  = "podIdentity.azureWorkload.tokenExpiration"
      type  = "string"
      value = var.token_expiration
    }
  }

  dynamic "set" {
    for_each = local.enable_irsa ? [true] : []
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/audience"
      value = "sts.amazonaws.com"
    }
  }

  dynamic "set" {
    for_each = local.enable_irsa ? [true] : []
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.irsa_role_arn
    }
  }

  dynamic "set" {
    for_each = local.enable_irsa ? [true] : []
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/sts-regional-endpoints"
      type  = "string"
      value = true
    }
  }

  dynamic "set" {
    for_each = local.enable_irsa ? [true] : []
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/token-expiration"
      type  = "string"
      value = var.token_expiration
    }
  }
}