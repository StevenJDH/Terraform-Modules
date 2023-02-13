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
 
resource "aws_dynamodb_table" "this" {
  name             = var.table_name
  billing_mode     = var.billing_mode
  table_class      = var.table_class
  read_capacity    = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity   = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  hash_key         = var.partition_key
  range_key        = var.sort_key
  stream_enabled   = var.enable_stream
  stream_view_type = var.enable_stream ? var.stream_view_type : null

  dynamic "attribute" {
    for_each = tomap({
      for idx, v in var.attributes : idx => v
    })

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_attribute_name != null ? [true] : []

    content {
      attribute_name = var.ttl_attribute_name
      enabled        = true
    }
  }

  dynamic "local_secondary_index" {
    for_each = length(var.local_secondary_indexes) < 1 ? {} : tomap({
      for v in var.local_secondary_indexes : v.name => v
    })
    iterator = lsi

    content {
      name               = lsi.key
      range_key          = lsi.value.sort_key
      projection_type    = lsi.value.projection_type
      non_key_attributes = lsi.value.projection_type == "INCLUDE" ? lsi.value.non_key_attributes : null
    }
  }

  dynamic "global_secondary_index" {
    for_each = length(var.global_secondary_indexes) < 1 ? {} : tomap({
      for v in var.global_secondary_indexes : v.name => v
    })
    iterator = gsi

    content {
      name               = gsi.key
      hash_key           = gsi.value.partition_key
      range_key          = gsi.value.sort_key
      read_capacity      = var.billing_mode == "PROVISIONED" ? gsi.value.read_capacity : null
      write_capacity     = var.billing_mode == "PROVISIONED" ? gsi.value.write_capacity : null
      projection_type    = gsi.value.projection_type
      non_key_attributes = gsi.value.projection_type == "INCLUDE" ? gsi.value.non_key_attributes : null
    }
  }

  tags = var.tags
}