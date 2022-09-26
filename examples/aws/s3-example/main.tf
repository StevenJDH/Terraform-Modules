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

module "s3-bucket" {
  source = "../../../aws/s3"

  bucket_name       = "tf-example-bucket-${local.stage}"
  add_random_suffix = true
  enable_versioning = true
  lifecycle_rules = [
    {
      rule_name               = "Housekeeping"
      enable_rule             = true
      version_expiration_days = 7
      delete_incomplete_mp_upload_days = 1
    },
  ]

  tags = local.tags
}