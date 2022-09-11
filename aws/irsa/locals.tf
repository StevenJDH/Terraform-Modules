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
  irsa_test_message = "Hello World!"
  oidc_audience     = "sts.amazonaws.com"

  irsa_test_config = {
    application_name          = "irsa-test-app"
    namespace_name            = "default"
    create_service_account    = true
    service_account_name      = "irsa-test-sa"
    service_account_token_exp = "86400"
    policy_arns               = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  }

  irsa_app_config = var.deploy_irsa_test ? concat(var.irsa_application_config, [local.irsa_test_config]) : var.irsa_application_config

  federated_subjects = [
    for v in local.irsa_app_config : format("system:serviceaccount:%s:%s", v.namespace_name, v.service_account_name)
  ]

  service_accounts = tomap({
    for k, v in local.irsa_app_config : k => v if v.create_service_account
  })

  policy_arns = flatten([
    for k, v in local.irsa_app_config : [
      for policy_arn in v.policy_arns : {
        key        = k
        policy_arn = policy_arn
      }
    ]
  ])
}