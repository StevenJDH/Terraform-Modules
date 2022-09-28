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

variable "eks_cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "irsa_application_config" {
  description = "Sets the irsa application configuration, which manages irsa service accounts, roles, token expiration, etc. Default irsa service account token expiration is \"86400\" (1 day) unless specified differently in seconds. If the irsa service account will be created by a helm project, set `create_service_account` to `false`, and ensure the defined namespace is used."
  type        = list(object({
    application_name          = string
    namespace_name            = string
    create_service_account    = bool
    service_account_name      = string
    service_account_token_exp = optional(string, "86400")
    policy_arns               = optional(list(string))
  }))

  default = []

  validation {
    condition = alltrue(
      [for v in var.irsa_application_config : (length(v.policy_arns) <= 20)]
    )
    error_message = "The number of policy ARNs for a role must not exceed 20. https://aws.amazon.com/premiumsupport/knowledge-center/iam-increase-policy-size"
  }
}

variable "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster."
  type        = string
}

variable "deploy_irsa_test" {
  description = "Deploys test resources to validate if the irsa setup is working using the AWS CLI and Credential Provider Chain. When done, make sure to set `deploy_irsa_test` to `false` to cleanup the test resources and avoid additional costs."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = null
}