terraform {
  required_version = ">= 0.9, < 0.10"
}

/**
 * Resources.
 */

# The ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}"
}

data "aws_ami" "latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aws_ami_latest_filter}"]
  }

  owners = ["${var.aws_ami_latest_owner}"]
}

resource "aws_security_group" "ecs_cluster_group" {
  name        = "${var.project}-${var.environment}-${var.cluster_name}-cluster-sg"
  description = "${var.project}-${var.environment}-${var.cluster_name}-cluster-sg"
  vpc_id      = "${var.security_vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Project     = "${var.project}"
    Environment = "${var.environment}"
    ClusterName = "${title(var.project)}-${var.environment}-${var.cluster_name}-cluster"
  }
}

# User data template that specifies how to bootstrap each instance
data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"
}

# The launch configuration for each EC2 Instance that will run in the cluster
resource "aws_launch_configuration" "ecs_instance" {
  name_prefix          = "${var.cluster_name}-instance-"
  instance_type        = "${var.instance["type"]}"
  key_name             = "${var.instance["key_name"]}"
  iam_instance_profile = "${var.instance["profile"]}"
  security_groups      = ["${aws_security_group.ecs_cluster_group.id}"]
  image_id             = "${var.instance["ami"] == "latest" ? data.aws_ami.latest.id : var.instance["ami"]}"
  user_data            = "${data.template_file.user_data.rendered}"

  # Important note: whenever using a launch configuration with an auto scaling
  # group, you must set create_before_destroy = true. However, as soon as you
  # set create_before_destroy = true in one resource, you must also set it in
  # every resource that it depends on, or we'll get an error about cyclic
  # dependencies (especially when removing resources). For more info, see:
  #
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  # https://terraform.io/docs/configuration/resources.html
  lifecycle {
    create_before_destroy = true
  }
}

# The auto scaling group that specifies how we want to scale the number of EC2 Instances in the cluster
resource "aws_autoscaling_group" "ecs_cluster" {
  name                 = "${var.cluster_name}-instances"
  min_size             = "${var.asg_min}"
  max_size             = "${var.asg_max}"
  launch_configuration = "${aws_launch_configuration.ecs_instance.name}"

  //  vpc_zone_identifier = ["${split(",", var.ecs_cluster_subnet_ids)}"]
  vpc_zone_identifier = "${var.instance_list_public_subnet_id}"
  health_check_type   = "EC2"

  //  target_group_arns = ["${var.target_group_arn}"]

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-instance"
    propagate_at_launch = true
  }
}
