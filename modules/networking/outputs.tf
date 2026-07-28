output "vpc_id" {
    description = "vpc id "
    value = aws_vpc.vpc.id 
}

output "igw_id" {
    description = "igw id "
    value = aws_internet_gateway.igw.id 
}

output "public_subnet_ids" {
    description = "public subnet id "
    value = aws_subnet.public[*].id 
}

output "private_subnet_ids" {
    description = "private subnet id "
    value = aws_subnet.private[*].id 
}

output "public_subnet_cidr" {
    description = "public subnet cidrs "
    value = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidr" {
    description = "private_subnet cidr "
    value = aws_subnet.private[*].cidr_block
}

output "aws_nat_gateway_id" {
    description = "aws_nat_gateway id"
    value = aws_nat_gateway.nat[*].id
}

output "aws_route_table_id_public" {
    description = "aws_route_table_public id"
    value = aws_route_table.public.id
}

output "aws_route_table_id_private" {
    description = "aws_route_table_id_private "
    value = aws_route_table.private[*].id
}

output "availability_zones" {
  description = "AZs used"
  value       = var.azs
}

