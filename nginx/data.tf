data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = "codurance-playground-terraform-remote"
    key    = "platform-engineer-test/infrastructure/terraform.tfstate"
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
