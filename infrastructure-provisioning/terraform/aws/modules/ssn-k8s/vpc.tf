resource "aws_vpc" "k8s-vpc" {
  count = var.vpc_id == "" ? 1 : 0
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.service_base_name}-vpc"
  }
}

resource "aws_internet_gateway" "k8s-igw" {
  count  = var.vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.k8s-vpc.0.id

  tags = {
    Name = "${var.service_base_name}-igw"
  }
}

resource "aws_route" "k8s-r" {
  count                     = var.vpc_id == "" ? 1 : 0
  route_table_id            = aws_vpc.k8s-vpc.0.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.k8s-igw.0.id
}

data "aws_vpc" "k8s-vpc-data" {
  id = var.vpc_id == "" ? aws_vpc.k8s-vpc.0.id : var.vpc_id
}

resource "aws_subnet" "k8s-subnet" {
  count                   = var.subnet_id == "" ? 1 : 0
  vpc_id                  = data.aws_vpc.k8s-vpc-data.id
  availability_zone       = "${var.region}${var.zone}"
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.service_base_name}-subnet"
  }
}

data "aws_subnet" "k8s-subnet-data" {
  id = var.subnet_id == "" ? aws_subnet.k8s-subnet.0.id : var.subnet_id
}

resource "aws_eip" "k8s-lb-eip" {
  vpc      = true
  tags = {
    Name = "${var.service_base_name}-eip"
  }
}