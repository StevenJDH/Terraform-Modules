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
  vpc_lambdas = tomap({
    for k, v in var.lambda_functions : k => v if (length(v.vpc_subnet_ids) > 0 && length(v.vpc_security_group_ids) > 0)
  })

  invoking_lambdas = tomap({
    for k, v in var.lambda_functions : k => v if v.invoke_with_payload != null
  })

  policy_arns = flatten([
    for k, v in var.lambda_functions : [
      for policy_arn in v.additional_policy_arns : {
        key        = k
        policy_arn = policy_arn
      }
    ]
  ])
}