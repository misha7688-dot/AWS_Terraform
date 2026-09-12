resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "${var.project}-vpc" })

  #  tags                 = { Name = "${var.project}-vpc" }
}
#resource "aws_subnet" "public" {
#  vpc_id                  = aws_vpc.main.id
#  cidr_block              = var.subnet_cidr
#  availability_zone       = "${var.region}a"
#  map_public_ip_on_launch = true
#  tags                    = { Name = "${var.project}-public" }
#}

#resource "aws_subnet" "private_b" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = "10.10.11.0/24"
#  availability_zone = "${var.region}b"

#  tags = {
#  Name = "${var.project}-private-b" }
#}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.project}-igw" })
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "${var.project}-rt" })
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.net["public-a"].id
  route_table_id = aws_route_table.public.id
}
resource "aws_subnet" "net" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = "${var.region}${each.value.az}"
  tags              = merge(var.tags, { Name = "${var.project}-${each.key}" })
}


locals {
  subnets = {
    public-a = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 1)
      az   = "a"
    }
    private-b = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 11)
      az   = "b"
    }
    private-c = {
      cidr = cidrsubnet(var.vpc_cidr, 8, 12)
      az   = "c"
    }
  }
}
