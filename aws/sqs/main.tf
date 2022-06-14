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

resource "aws_sqs_queue" "this" {
  count = length(var.queue_names)
  
  name                              = var.fifo_queue ? "${var.queue_names[count.index]}.fifo" : var.queue_names[count.index]
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.fifo_queue ? var.content_based_deduplication : null
  deduplication_scope               = var.fifo_queue ? var.deduplication_scope : null
  delay_seconds                     = var.delay_seconds
  message_retention_seconds         = var.message_retention_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  redrive_policy                    = var.create_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[count.index].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = var.tags
}

resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq ? length(var.queue_names) : 0

  name                              = var.fifo_queue ? "${var.queue_names[count.index]}-dlq.fifo" : "${var.queue_names[count.index]}-dlq"
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.fifo_queue ? var.content_based_deduplication : null
  deduplication_scope               = var.fifo_queue ? var.deduplication_scope : null
  message_retention_seconds         = var.message_retention_dlq_seconds
  visibility_timeout_seconds        = var.visibility_timeout_dlq_seconds
  redrive_allow_policy              = jsonencode({
    redrivePermission = "byQueue",
    # Workaround for Cycle error https://github.com/hashicorp/terraform-provider-aws/issues/22577.
    sourceQueueArns   = [
      var.fifo_queue ?
      "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.queue_names[count.index]}.fifo" :
      "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.queue_names[count.index]}",
    ]
  })

  tags = var.tags
}