output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "management_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.management[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
 