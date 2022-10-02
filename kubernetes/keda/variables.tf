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

variable "create_keda_namespace" {
  description = "Indicates whether or not to create a namespace for KEDA."
  type        = bool
  default     = true
}

variable "keda_namespace" {
  description = "Default namespace for KEDA."
  type        = string
  default     = "keda"
}

variable "keda_version" {
  description = "Version of KEDA to deploy if latest is not desired or version pinning is needed."
  type        = string
  default     = "latest"
}

variable "enable_azwi_system" {
  description = "Indicates whether or not to use Azure AD Workload Identity system (AZWI) for federated access without having to manage passwords in secrets. Requires [Azure Workload Identity Module](https://github.com/StevenJDH/Terraform-Modules/tree/main/azure/workload-identity) installed or made available through other means. Conflicts with `enable_irsa`."
  type        = bool
  default     = false
}

variable "azwi_client_id" {
  description = "The clientId of the KEDA app registration in Azure AD for the azwi system. These will be set as an annotation on the KEDA service account. Tenant Id is set automatically. For `TriggerAuthentication` resources, set `spec.podIdentity.provider` to `azure-workload` and `spec.podIdentity.identityId` with a separate app registration clientId along with the needed Azure role associations to not share privileges. See [Re-use credentials and delegate auth with TriggerAuthentication](https://keda.sh/docs/2.8/concepts/authentication/#re-use-credentials-and-delegate-auth-with-triggerauthentication) for more information."
  type        = string
  default     = null
}

variable "token_expiration" {
  description = "Sets the KEDA service account token expiration in seconds for the azwi system and irsa. This will be set as an annotation on the KEDA service account."
  type        = string
  default     = "3600"
}

variable "enable_irsa" {
  description = "Indicates whether or not to use AWS IAM Roles for Service Accounts (IRSA) for federated access without having to manage passwords in secrets. Requires [AWS IAM Roles for Service Accounts (IRSA) Module](https://github.com/StevenJDH/Terraform-Modules/tree/main/aws/irsa) installed or made available through other means. Conflicts with `enable_azwi_system`."
  type        = bool
  default     = false
}

variable "irsa_role_arn" {
  description = "ARN of an IAM role with a web identity provider. This will be set as an annotation on the KEDA service account. For `TriggerAuthentication` resources, set `spec.podIdentity.provider` to `aws-eks` and use a separate app specific role along with the needed policy associations to not share privileges. See [Re-use credentials and delegate auth with TriggerAuthentication](https://keda.sh/docs/2.8/concepts/authentication/#re-use-credentials-and-delegate-auth-with-triggerauthentication) for more information."
  type        = string
  default     = null
}