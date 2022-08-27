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

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames

  tags = merge(
    { Name = var.name },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_subnet" "this" {
  for_each = tomap({
    for k, v in var.subnet_configuration : k => v
  })

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, each.value.new_bits, each.key)
  availability_zone       = element(data.aws_availability_zones.available.names, index(local.zone_suffixes, each.value.availability_zone))
  map_public_ip_on_launch = each.value.make_public

  tags = merge(
    { Name = each.value.subnet_name != null ? each.value.subnet_name : format("subnet-${each.value.make_public ? "pub" : "priv"}-%s-%s-${each.key + 1}-${var.name}",
      cidrsubnet(var.cidr_block, each.value.new_bits, each.key),
      element(data.aws_availability_zones.available.names, index(local.zone_suffixes, each.value.availability_zone)))},
    var.tags,
    each.value.make_public ? var.public_subnet_tags : var.private_subnet_tags,
  )
}

resource "aws_route" "default-ngw" {
  count = var.add_default_routes && length(local.public_subnet_nats) == 1 ? 1 : 0

  route_table_id         = aws_vpc.this.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public[0].id
}

resource "aws_route" "default-egress_only_igw" {
  count = var.enable_ipv6 && var.add_default_routes && var.create_egress_only_internet_gateway  ? 1 : 0

  route_table_id              = aws_vpc.this.default_route_table_id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}

resource "aws_route_table" "private-gateway" {
  count = var.single_private_route_table && length(local.private_subnet_nats) > 0 ? 1 : length(local.private_subnet_nats)

  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = format("rtb-priv-ngw-%s-%s", count.index + 1, var.name) },
    var.tags,
    var.private_ngw_route_table_tags,
  )
}

resource "aws_route_table_association" "private-gateway" {
  count = length(local.private_subnet_nats)

  subnet_id      = aws_subnet.this[local.private_subnet_nats[count.index]].id
  route_table_id = var.single_private_route_table ? aws_route_table.private-gateway[0].id : aws_route_table.private-gateway[count.index].id
}

resource "aws_route_table" "gateway" {
  count = var.single_public_route_table && length(local.public_subnets) > 0 ? 1 : length(local.public_subnets)

  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = format("rtb-pub-%s-%s", count.index + 1, var.name) },
    var.tags,
    var.igw_route_table_tags,
  )
}

resource "aws_route_table_association" "gateway" {
  count = length(local.public_subnets)

  subnet_id      = aws_subnet.this[local.public_subnets[count.index]].id
  route_table_id = var.single_public_route_table ? aws_route_table.gateway[0].id : aws_route_table.gateway[count.index].id
}

resource "aws_route" "gateway-ipv4" {
  count = var.add_default_routes && local.igw_will_be_created ? local.gateway_default_routes_count : 0

  route_table_id         = aws_route_table.gateway[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route" "gateway-ipv6" {
  count = var.enable_ipv6 && var.add_default_routes && local.igw_will_be_created ? local.gateway_default_routes_count : 0

  route_table_id              = aws_route_table.gateway[count.index].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this[0].id
}

resource "aws_nat_gateway" "private" {
  count = length(local.private_subnet_nats)

  subnet_id         = aws_subnet.this[local.private_subnet_nats[count.index]].id
  connectivity_type = "private"

  tags = merge(
    { Name = format("ngw-priv-%s-${local.private_subnet_nats[count.index] + 1}-%s",
      aws_subnet.this[local.private_subnet_nats[count.index]].availability_zone, var.name) },
    var.tags,
    var.private_ngw_tags,
  )
}

resource "aws_eip" "nat" {
  count = length(local.public_subnet_nats)

  vpc = true

  tags = merge(
    { Name = format("eip-%s-${local.public_subnet_nats[count.index] + 1}-%s",
      aws_subnet.this[local.public_subnet_nats[count.index]].availability_zone, var.name) },
    var.tags,
    var.eip_public_nat_tags,
  )
}

resource "aws_nat_gateway" "public" {
  count = length(local.public_subnet_nats)

  allocation_id     = element(aws_eip.nat[*].id, count.index)
  subnet_id         = aws_subnet.this[local.public_subnet_nats[count.index]].id
  connectivity_type = "public"

  tags = merge(
    { Name = format("ngw-pub-%s-${local.public_subnet_nats[count.index] + 1}-%s",
      aws_subnet.this[local.public_subnet_nats[count.index]].availability_zone, var.name) },
    var.tags,
    var.public_ngw_tags,
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_internet_gateway" "this" {
  count = local.igw_will_be_created ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = format("igw-%s", var.name) },
    var.tags,
    var.igw_tags,
  )
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.create_egress_only_internet_gateway && var.enable_ipv6 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = format("eigw-%s", var.name) },
    var.tags,
    var.eigw_tags,
  )
}