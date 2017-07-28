#
# Module m-bastion
#
# 1 - Security Group
# 2 - Launch Configuration (if Autoscaling = true)
# 3 - Autoscaling (if Autoscaling = true)
# 3 - Bastion host (if Autoscaling = false)

# Latest amazon nat machine, hvm available for the region. To be used in the
# launch_configuration group
# TMP: amzn-ami-vpc-nat-hvm-2017.03.1.20170623-x86_64-ebs (ami-36af2055)
data "aws_ami" "bastion" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn-ami*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
  name   = "owner-alias"
  values = ["amazon"]
  }
}


# Security Group
resource "aws_security_group" "bastion_security_group" {
  name  = "${var.m_environment} SSH only for bastion host"
  description = "Bastion security group"
  vpc_id      = "${var.m_vpc_id}"

  lifecycle {
      create_before_destroy = true
  }
  tags   = "${merge(var.m_tags, map("Name", format("%s-sg", var.m_o_name)))}"

}
# Allow TCP:22 (SSH)
resource "aws_security_group_rule" "ingress_tcp_22_cidr" {
  security_group_id = "${aws_security_group.bastion_security_group.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}

resource "aws_security_group_rule" "egress_all" {
  security_group_id = "${aws_security_group.bastion_security_group.id}"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

# Launch Configuration
resource "aws_launch_configuration" "bastion" {
  name   = "${var.m_environment} launch configuration for bastion host only"
  image_id      = "${data.aws_ami.bastion.id}" #output from the data-source
  instance_type = "${var.m_bastion_class}"
  security_groups = ["${aws_security_group.bastion_security_group.id}"]
  key_name        = "${var.m_key_name}"
  user_data       = "${file("${path.module}/scripts/bastion.sh")}"

  count = "${var.m_enable_bastion_autoscale ? 1 : 0}"

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling group
resource "aws_autoscaling_group" "bastion" {
  name = "${var.m_environment} autoscaling group for bastion host only"

  vpc_zone_identifier = ["${var.m_public_subnets}"]

  desired_capacity          = "${length("${var.m_public_subnets}")}"
  min_size                  = "1"
  max_size                  = "${length("${var.m_public_subnets}")}"
  health_check_grace_period = "300"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.bastion.id}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  count = "${var.m_enable_bastion_autoscale ? 1 : 0}"

  lifecycle {
    create_before_destroy = true
  }
}
