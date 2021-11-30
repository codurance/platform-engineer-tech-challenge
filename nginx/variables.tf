variable "region" {
  description = "AWS region name"
  default     = "eu-west-2"
}
variable "name_prefix" {
  description = "Launch configuration name prefix"
  type = string
  default = "nginx_config-"
}

variable "instance_type" {
  description = "EC2 Instance type"
  type = string
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH key name"
  type = string
  default = "platform-engineer-test"
}
