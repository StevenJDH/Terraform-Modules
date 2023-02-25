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

resource "aws_sns_topic" "this" {
  count = length(var.topic_names)

  name                        = var.fifo_topic ? "${var.topic_names[count.index]}.fifo" : var.topic_names[count.index]
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.fifo_topic ? var.content_based_deduplication : null
  delivery_policy             = jsonencode({
    http = {
      defaultHealthyRetryPolicy = {
        minDelayTarget     = var.min_delay_target_seconds
        maxDelayTarget     = var.max_delay_target_seconds
        numRetries         = var.num_retries
        numMaxDelayRetries = var.num_max_delay_retries
        numNoDelayRetries  = var.num_no_delay_retries
        numMinDelayRetries = var.num_min_delay_retries
        backoffFunction    = var.backoff_function
      }
      disableSubscriptionOverrides = false
      defaultThrottlePolicy = {
        maxReceivesPerSecond = var.max_receives_per_second
      }
    }
  })

  tags = var.tags
}