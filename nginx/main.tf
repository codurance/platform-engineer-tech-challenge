terraform {
  backend "s3" {
    bucket = "codurance-playground-terraform-remote"
    key    = "platform-engineer-test/nginx/terraform.tfstate"
    region = "eu-west-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

locals {
  image_id  = data.aws_ami.latest_amazon_linux_2_ami.id
  user_data = data.template_file.user_data.rendered
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "codurance-dpm-terraform-remote"
    key    = "platform-engineer-test/networks/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "latest_amazon_linux_2_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/lib/bootstrap.sh.tpl")
}

resource "aws_autoscaling_group" "asg" {
  name                      = "nginx-asg"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.lg.id
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["${data.terraform_remote_state.network.public_subnet_ids}"]

  tags = {
    key                 = "Name"
    value               = "nginx"
    propagate_at_launch = true
  }
}
resource "aws_launch_configuration" "lg" {
  name_prefix                 = var.name_prefix 
  image_id                    = local.image_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  user_data                   = local.user_data
  security_groups             = ["${aws_security_group.security_group.id}"]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "platform-engineer-test" {
  key_name   = "platform-engineer-test"
  public_key = file("./keypairs/id_rsa.pub")
}

resource "aws_security_group" "security_group" {
  vpc_id = data.terraform_remote_state.network.vpc_id
  name   = "nginx-security-group"
}

resource "aws_security_group_rule" "egress_to_anywhere" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.security_group.id
}
