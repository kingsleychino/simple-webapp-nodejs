output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "project_name" {
  value = var.project_name
}

output "region" {
  value = var.region
}
