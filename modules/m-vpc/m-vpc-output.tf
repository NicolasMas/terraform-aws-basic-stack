output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "vpc_default_security_group" {
  value = "${aws_vpc.vpc.default_security_group_id}"
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

output "default_security_group_id" {
  value = "${aws_vpc.vpc.default_security_group_id}"
}

output "nat_eips" {
  value = ["${aws_eip.nateip.*.id}"]
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "memory" {
    value = "${var.m_o_memory}"
}

output "tenancy" {
    value = "${aws_vpc.vpc.instance_tenancy}"
}
