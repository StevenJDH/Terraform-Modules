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

module "sns-topics" {
  source = "../../../aws/sns"

  topic_names   = ["tf-sns-example-${local.stage}"]

  tags = local.tags
}

module "sns-fifo-topics" {
  source = "../../../aws/sns"

  topic_names = ["tf-sns-example2-${local.stage}"]
  fifo_topic  = true

  tags = local.tags
}