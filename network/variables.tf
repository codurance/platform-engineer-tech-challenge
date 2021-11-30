variable "region" {
  description = "AWS region name"
  default     = "eu-west-2"
}

variable "vpc_cidr_block" {
  description = "VPC Cidr Block. This is related to the vpc_subnet_bitmask variable."
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "The name of the environment"
  default     = "production"
}

variable "service_name" {
  description = "The name of the network"
  default     = "tech-test"
}

variable "availability_zones" {
  description = "The availability zones over which to span the network"
  type        = list(string)

  default = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c",
  ]
}
