/*
 * This file is part of Terraform-Modules <https://github.com/StevenJDH/Terraform-Modules>.
 * Copyright (C) 2022-2023 Steven Jenkins De Haro.
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

module "db-table" {
  source = "../../../aws/dynamodb"

  table_name         = "TF_Customer_Orders_Example_${upper(local.stage)}"
  billing_mode       = "PAY_PER_REQUEST"
  partition_key      = "pk_customer_id"
  sort_key           = "sk_order_date"
  enable_stream      = true
  stream_view_type   = "NEW_IMAGE"
  ttl_attribute_name = "ttl"

  attributes = [
    {
      name = "pk_customer_id"
      type = "S"
    },
    {
      name = "sk_order_date"
      type = "S"
    },
  ]

  global_secondary_indexes = [
    {
      name               = "example_idx"
      partition_key      = "pk_customer_id"
      sort_key           = "sk_order_date"
      projection_type    = "KEYS_ONLY"
    },
  ]

  tags = local.tags
}