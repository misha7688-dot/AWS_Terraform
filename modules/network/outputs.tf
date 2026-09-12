output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = {
    for k, subnet in aws_subnet.net : k => subnet.id
  }
}
