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

resource "aws_acm_certificate" "this" {
  count = local.enable_acm_custom_domain ? 1 : 0

  domain_name       = local.api_custom_fqdn
  validation_method = "DNS"

  # It's recommended to specify this to replace a certificate which
  # is currently in use.
  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_route53_record" "validation" {
  for_each = local.domain_validation_options

  zone_id         = data.aws_route53_zone.public-zone[0].zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = "300"
  allow_overwrite = false
}

resource "aws_acm_certificate_validation" "this" {
  count = local.enable_acm_custom_domain ? 1 : 0

  certificate_arn         = aws_acm_certificate.this[0].arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_api_gateway_domain_name" "this" {
  count = local.enable_acm_custom_domain ? 1 : 0

  domain_name              = local.api_custom_fqdn
  regional_certificate_arn = aws_acm_certificate_validation.this[0].certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = [var.endpoint_type]
  }

  tags = var.tags
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count = local.enable_acm_custom_domain ? 1 : 0

  api_id      = aws_api_gateway_rest_api.this.id
  domain_name = aws_api_gateway_domain_name.this[0].domain_name
  stage_name  = aws_api_gateway_stage.this.stage_name
  base_path   = replace(local.api_domain_subdirectory, "/", "")
}

resource "aws_route53_record" "this" {
  count = local.enable_acm_custom_domain ? 1 : 0

  zone_id = data.aws_route53_zone.public-zone[0].zone_id
  name    = aws_api_gateway_domain_name.this[0].domain_name
  type    = "A"

  alias {
    name                   = var.endpoint_type == "REGIONAL" ? aws_api_gateway_domain_name.this[0].regional_domain_name : aws_api_gateway_domain_name.this[0].cloudfront_domain_name
    zone_id                = var.endpoint_type == "REGIONAL" ? aws_api_gateway_domain_name.this[0].regional_zone_id : aws_api_gateway_domain_name.this[0].cloudfront_zone_id
    evaluate_target_health = false
  }
}