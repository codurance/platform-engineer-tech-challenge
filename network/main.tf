terraform {
  backend "s3" {
    bucket = "codurance-playground-terraform-remote"
    key    = "platform-engineer-test/networks/terraform.tfstate"
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
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.service_name}-${var.environment}-internet-gateway"
    Type        = "VPC Internet Gateway"
    Environment = var.environment
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.service_name}-${var.environment}-public-route-table"
    Type        = "VPC Route Table"
    Environment = var.environment
  }
}

resource "aws_route" "internet_gateway_public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.subnet_public.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "subnet_public" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, length(var.availability_zones), count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.service_name}-${var.environment}-subnet-public-${element(var.availability_zones, count.index)}"
    Type        = "VPC Public Subnet"
    Environment = var.environment
  }
}
