output "public_ip" {
  value = aws_instance.web.public_ip
}
output "url" {
  value = "http://${aws_instance.web.public_ip}"
}
output "vpc_id" {
  value = module.network.vpc_id
}
output "subnet_net" {
  value = module.network.subnet_ids
}
