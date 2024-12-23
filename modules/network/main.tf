# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.environment}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.environment}-private-${count.index}"
  }
}


resource "aws_subnet" "management" {
  count             = length(var.management_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.management_subnet_cidrs[count.index]
  availability_zone = "us-east-1c"
  tags = {
    Name = "${var.environment}-management-${count.index}"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-igw"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.environment}-public-route"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.environment}-private-route"
  }
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Route Table for Management Subnets
resource "aws_route_table" "management" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.environment}-management-route"
  }
}

# Route Table Association for Management Subnets
resource "aws_route_table_association" "management" {
  count          = length(aws_subnet.management)
  subnet_id      = aws_subnet.management[count.index].id
  route_table_id = aws_route_table.management.id
}