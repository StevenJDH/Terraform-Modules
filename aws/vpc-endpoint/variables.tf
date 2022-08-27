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

variable "name" {
  description = "The name of the PrivateLink."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used."
  type        = string
}

variable "service_name" {
  description = "The service name. For AWS services, the service name is usually in the form `com.amazonaws.<region>.<service>` (the SageMaker Notebook service is an exception to this rule, the service name is in the form `aws.sagemaker.<region>.notebook`). See [AWS services that integrate with AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html) for more details. Not providing a value for endpoints of type GatewayLoadBalancer creates a new endpoint service that will be used."
  type        = string
  default     = null
}

variable "enable_private_dns" {
  description = "Indicates whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface for AWS services and AWS Marketplace partner services only."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The IP address type for the endpoint. Valid values are ipv4, dualstack, and ipv6."
  type        = string
  default     = "ipv4"
  validation {
    condition     = contains(["ipv4", "dualstack", "ipv6"], var.ip_address_type)
    error_message = "Required IP address types can only be ipv4, dualstack, and ipv6."
  }
}

variable "subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface."
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "One or more route table IDs. Applicable for endpoints of type Gateway."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint."
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_type" {
  description = "The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface."
  type        = string
  default     = "Gateway"
  validation {
    condition     = contains(["Gateway", "GatewayLoadBalancer", "Interface"], var.vpc_endpoint_type)
    error_message = "Required endpoint types can only be Gateway, GatewayLoadBalancer, or Interface."
  }
}

variable "dns_record_ip_type" {
  description = "The DNS records created for the endpoint. Only used when `enable_private_dns` is `true`. Valid values are ipv4, dualstack, service-defined, and ipv6."
  type        = string
  default     = "ipv4"
  validation {
    condition     = contains(["ipv4", "dualstack", "service-defined", "ipv6"], var.dns_record_ip_type)
    error_message = "Required DNS record IP types can only be ipv4, dualstack, service-defined, and ipv6."
  }
}

variable "gateway_load_balancer_arns" {
  description = "ARNs of one or more Gateway Load Balancers for the endpoint service. Applicable for endpoints of type GatewayLoadBalancer."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = null
}

variable "vpce_tags" {
  description = "Additional tags for the PrivateLink."
  type        = map(string)
  default     = null
}

variable "vpce_svc_tags" {
  description = "Additional tags for the GatewayLoadBalancer PrivateLink Service."
  type        = map(string)
  default     = null
}