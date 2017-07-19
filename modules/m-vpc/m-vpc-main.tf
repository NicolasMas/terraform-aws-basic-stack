#
# Module m-vpc
#


###
#
# Building the VPC
resource "aws_vpc" "vpc" {
  # required
  cidr_block           = "${var.m_cidr}"
  enable_dns_support   = "${var.m_enable_dns_support}"
  enable_dns_hostnames = "${var.m_enable_dns_hostnames}"

  # optional
  instance_tenancy   = "${var.m_o_instance_tenancy}"

  # tags
  tags = "${merge(var.m_tags, map("Name", format("%s", var.m_o_name)))}"

  # lifecycle
  lifecycle {
    create_before_destroy = true
  }
}

# Building the IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(var.m_tags, map("Name", format("%s-igw", var.m_o_name)))}"
}

# Route table for the public subnet(s)
resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.vpc.id}"
  propagating_vgws = ["${var.m_public_propagating_vgws}"]
  tags             = "${merge(var.m_tags, map("Name", format("%s-rt-public-%s", var.m_o_name, element(var.m_azs, count.index))))}"
}
## Routes for the public route table
### IGW route
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

### route to the private subnet(s) via the nat gateway(s) (if enabled)
resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  count                  = "${length(var.m_private_subnets) * lookup(map(var.m_enable_nat_gateway, 1), "true", 0)}"
}

# Route table for the private subnet(s)
resource "aws_route_table" "private" {
  vpc_id           = "${aws_vpc.vpc.id}"
  propagating_vgws = ["${var.m_private_propagating_vgws}"]
  count            = "${length(var.m_private_subnets)}"
  tags             = "${merge(var.m_tags, map("Name", format("%s-rt-private-%s", var.m_o_name, element(var.m_azs, count.index))))}"

}

# Private subnet(s)
resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.m_private_subnets[count.index]}"
  availability_zone = "${element(var.m_azs, count.index)}"
  count             = "${length(var.m_private_subnets)}"
  tags              = "${merge(var.m_tags, map("Name", format("%s-subnet-private-%s", var.m_o_name, element(var.m_azs, count.index))))}"
}

# Associating the private subnet(s) with the private route table
resource "aws_route_table_association" "private_subnet_to_private_route" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  count          = "${length(var.m_private_subnets)}"
}

# Public subnet(s)
resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.m_public_subnets[count.index]}"
  availability_zone = "${element(var.m_azs, count.index)}"
  count             = "${length(var.m_public_subnets)}"
  tags              = "${merge(var.m_tags, map("Name", format("%s-subnet-public-%s", var.m_o_name, element(var.m_azs, count.index))))}"

  map_public_ip_on_launch = "${var.m_map_public_ip_on_launch}"
}

# Associating the public subnet(s) with the public route table
resource "aws_route_table_association" "public_subnet_to_public_route" {
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
  count          = "${length(var.m_public_subnets)}"
}

# Depending on whether NAT gateway(s) are set to true or false. NAT gateways
# require an EIP.
resource "aws_eip" "nateip" {
  vpc   = true
  count = "${length(var.m_private_subnets) * lookup(map(var.m_enable_nat_gateway, 1), "true", 0)}"
}
# NAT Gateways are replacing the NAT instances. They need to always be placed in
# a public subnet
resource "aws_nat_gateway" "natgw" {
  allocation_id = "${element(aws_eip.nateip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  count         = "${length(var.m_private_subnets) * lookup(map(var.m_enable_nat_gateway, 1), "true", 0)}"

  depends_on = ["aws_internet_gateway.igw"]
}
