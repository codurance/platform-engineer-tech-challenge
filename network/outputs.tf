output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.subnet_public.*.id
}

output "public_subnet_cidrs" {
  value = aws_subnet.subnet_public.*.cidr_block
}

output "public_route_table_ids" {
  value = aws_route_table.public_route_table.*.id
}
