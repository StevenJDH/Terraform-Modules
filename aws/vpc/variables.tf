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
  description = "The name of the VPC, which is also used as part of the name for all resources."
  type        = string
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  description = "Indicates whether or not to enable/disable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Indicates whether or not to enable/disable DNS hostnames in the VPC. Required for PrivateLinks and EKS."
  type        = bool
  default     = false
}

variable "subnet_configuration" {
  description = "Sets the private and public subnet configuration. Optionally override subnet name, choose the availability zone using letters a to c, mark the subnet as public or not, and add multiple private or public NAT Gateways as needed. The new_bits attribute is the number of additional bits that defines the subnet's IPv4 CIDR block. For multiple NATs across different AZs for high availability, each private subnet will point to its paired public subnet or the last one listed. For example, the first listed private subnet will point to the first listed public subnet with a public NAT and so on."
  type        = list(object({
    subnet_name               = optional(string)
    new_bits                  = number
    availability_zone         = string
    make_public               = bool
    create_nat_gateway        = bool
  }))
  default = [
    {
      subnet_name               = null
      new_bits                  = 8
      availability_zone         = "a"
      make_public               = false
      create_nat_gateway        = false
    },
  ]
  validation {
    condition = alltrue(
      [for v in var.subnet_configuration : (contains(["a", "b", "c"], v["availability_zone"]))]
    )
    error_message = "Required availability zone can only be a, b, or c."
  }
}

variable "default_acl_ingress_rules" {
  description = "Configuration for default ACL ingress rules."
  type = list(object({
    rule_no         = number
    action          = string
    protocol        = number
    from_port       = number
    to_port         = number
    cidr_block      = optional(string)
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
  default = [
    {
      rule_no         = 100
      action          = "allow"
      protocol        = -1
      from_port       = 0
      to_port         = 0
      cidr_block      = "0.0.0.0/0"
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
    },
  ]
}

variable "default_acl_egress_rules" {
  description = "Configuration for default ACL egress rules."
  type = list(object({
    rule_no         = number
    action          = string
    protocol        = number
    from_port       = number
    to_port         = number
    cidr_block      = optional(string)
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
  default = [
    {
      rule_no         = 100
      action          = "allow"
      protocol        = -1
      from_port       = 0
      to_port         = 0
      cidr_block      = "0.0.0.0/0"
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
    },
  ]
}

variable "default_security_group_ingress_rules" {
  description = "Configuration for default security group ingress rules."
  type = list(object({
    description      = optional(string)
    protocol         = string
    from_port        = number
    to_port          = number
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(set(string))
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    self             = optional(bool)
  }))
  default = [
    {
      description      = null
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      prefix_list_ids  = null
      security_groups  = null
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      self             = true
    },
  ]
}

variable "default_security_group_egress_rules" {
  description = "Configuration for default security group egress rules."
  type = list(object({
    description      = optional(string)
    protocol         = string
    from_port        = number
    to_port          = number
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(set(string))
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    self             = optional(bool)
  }))
  default = [
    {
      description      = null
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      prefix_list_ids  = null
      security_groups  = null
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      self             = null
    },
  ]
}

variable "single_private_route_table" {
  description = "Indicates whether or not to keep private subnets on the default route table, or provision each private subnet its own route table."
  type        = bool
  default     = true
}

variable "single_public_route_table" {
  description = "Indicates whether or not to provision a single shared route table for public subnets, or provision each public subnet its own route table."
  type        = bool
  default     = true
}

variable "create_internet_gateway" {
  description = "Indicates whether or not to create an Internet Gateway for public subnets. Even if set to false, it will still be created if a public NAT is created."
  type        = bool
  default     = false
}

variable "create_egress_only_internet_gateway" {
  description = "Indicates whether or not to create an Egress Only Internet Gateway for private subnets with support for IPv6 addresses. The enable_ipv6 attribute must also be set to true."
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
  type        = bool
  default     = false
}

variable "add_default_routes" {
  description = "Indicates whether or not to add default routes when possible to a public NAT in the default route table or any private route tables, and the Internet Gateway to any gateway route tables."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = null
}

variable "vpc_tags" {
  description = "Additional tags for the VPC."
  type        = map(string)
  default     = null
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets."
  type        = map(string)
  default     = null
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets."
  type        = map(string)
  default     = null
}

variable "default_private_route_table_tags" {
  description = "Additional tags for the default private route table."
  type        = map(string)
  default     = null
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables."
  type        = map(string)
  default     = null
}

variable "default_acl_tags" {
  description = "Additional tags for the default ACL."
  type        = map(string)
  default     = null
}

variable "default_security_group_tags" {
  description = "Additional tags for the default security group."
  type        = map(string)
  default     = null
}

variable "private_ngw_route_table_tags" {
  description = "Additional tags for the private NAT Gateway route tables."
  type        = map(string)
  default     = null
}

variable "igw_route_table_tags" {
  description = "Additional tags for the Internet Gateway route tables."
  type        = map(string)
  default     = null
}

variable "private_ngw_tags" {
  description = "Additional tags for the private NAT Gateway."
  type        = map(string)
  default     = null
}

variable "eip_public_nat_tags" {
  description = "Additional tags for the public NAT Gateway Elastic IP."
  type        = map(string)
  default     = null
}

variable "public_ngw_tags" {
  description = "Additional tags for the public NAT Gateway."
  type        = map(string)
  default     = null
}

variable "igw_tags" {
  description = "Additional tags for the Internet Gateway."
  type        = map(string)
  default     = null
}

variable "eigw_tags" {
  description = "Additional tags for the Egress Only Internet Gateway."
  type        = map(string)
  default     = null
}