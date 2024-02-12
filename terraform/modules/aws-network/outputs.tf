output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC."
}

output "private_subnet_ids" {
  value = toset([
    for i in aws_subnet.private : i.id
  ])
  description = "List of ID of the pvt Subnets."
}
  
 /*  value = toset([
    for i in aws_subnet.private : i.id
  ]) */

output "public_subnet_ids" {
  value = toset([
    for i in aws_subnet.public : i.id
  ])
  description = "List of  ID of the public Subnets."
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.gw.id
  description = "The ID of the Internet Gateway."
}

