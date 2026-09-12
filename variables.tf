variable "project" {
  type    = string
  default = "tf-shop"
}
variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}
variable "subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "subnets" {
  type = map(object({ cidr = string, az = string }))
  default = {
    #    public-a = { cidr = cidrsubnet(var.vpc.cidr, 8, 1), az = "a" }
    public-a = { cidr = "10.10.1.0/24", az = "a" }
    #    private-b = { cidr = cidrsubnet(var.vpc.cidr, 8, 11), az = "b" }
    private-b = { cidr = "10.10.11.0/24", az = "b" }
    #    private-c = { cidr = cidrsubnet(var.vpc.cidr, 8, 12), az = "c" }
    private-c = { cidr = "10.10.12.0/24", az = "c" }
  }
}
variable "env" {
  type    = string
  default = "dev"
}
