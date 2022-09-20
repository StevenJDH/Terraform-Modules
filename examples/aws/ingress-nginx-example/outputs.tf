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

output "ingress_nginx_no_tls_controller_nlb_name" {
  value = module.ingress-nginx-no-tls.ingress_controller_nlb_name
}

output "ingress_nginx_no_tls_controller_nlb_hostname" {
  value = module.ingress-nginx-no-tls.ingress_controller_nlb_hostname
}

output "ingress_nginx_no_tls_controller_nlb_arn" {
  value = module.ingress-nginx-no-tls.ingress_controller_nlb_arn
}

output "ingress_nginx_nlb_terminated_controller_nlb_name" {
  value = module.ingress-nginx-nlb-terminated.ingress_controller_nlb_name
}

output "ingress_nginx_nlb_terminated_controller_nlb_hostname" {
  value = module.ingress-nginx-nlb-terminated.ingress_controller_nlb_hostname
}

output "ingress_nginx_nlb_terminated_controller_nlb_arn" {
  value = module.ingress-nginx-nlb-terminated.ingress_controller_nlb_arn
}

output "ingress_nginx_terminated_controller_nlb_name" {
  value = module.ingress-nginx-terminated.ingress_controller_nlb_name
}

output "ingress_nginx_terminated_controller_nlb_hostname" {
  value = module.ingress-nginx-terminated.ingress_controller_nlb_hostname
}

output "ingress_nginx_terminated_controller_nlb_arn" {
  value = module.ingress-nginx-terminated.ingress_controller_nlb_arn
}

output "ingress_nginx_terminated_cert_manager_dns01_role_arn" {
  value = module.ingress-nginx-terminated.cert_manager_dns01_role_arn
}