# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.deploy_name}-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.deploy_name}-igw"
  }
}
########################
# PUBLIC
########################
# Public Route Table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.deploy_name}-public-route-table"
  }
}

# Public Subnet A
resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.deploy_name}-public-subnet-a"
  }
}

# Public Route Table Association A
resource "aws_route_table_association" "public-route-table-association-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public-route-table.id
}

# Public Subnet B
resource "aws_subnet" "public-subnet-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.deploy_name}-public-subnet-b"
  }
}

# Public Route Table Association B
resource "aws_route_table_association" "public-route-table-association-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public-route-table.id
}

########################
# PRIVATE
########################
# Private Subnet A
resource "aws_subnet" "private-subnet-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.deploy_name}-private-subnet-a"
  }
}

# Private Route Table Association A 
resource "aws_route_table_association" "private-route-table-association-a" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.private-route-table-a.id
}

# Private Subnet B
resource "aws_subnet" "private-subnet-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.deploy_name}-private-subnet-b"
  }
}

# Private Route Table Association B
resource "aws_route_table_association" "private-route-table-association-b" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.private-route-table-b.id
}


# Private Route Table A
resource "aws_route_table" "private-route-table-a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-a.id
  }

  tags = {
    Name = "${var.deploy_name}-private-route-table-a"
  }
}

# Private Route Table B
resource "aws_route_table" "private-route-table-b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway-b.id
  }

  tags = {
    Name = "${var.deploy_name}-private-route-table-b"
  }
}

# NAT Gateway A
resource "aws_nat_gateway" "nat-gateway-a" {
  allocation_id = aws_eip.private-nat-eip-a.allocation_id
  subnet_id     = aws_subnet.private-subnet-a.id
  depends_on    = [aws_internet_gateway.igw]
}

# NAT Gateway B
resource "aws_nat_gateway" "nat-gateway-b" {
  allocation_id = aws_eip.private-nat-eip-b.allocation_id
  subnet_id     = aws_subnet.private-subnet-b.id
  depends_on    = [aws_internet_gateway.igw]
}

# Elastic IP
resource "aws_eip" "private-nat-eip-a" {
  vpc = true
}

resource "aws_eip" "private-nat-eip-b" {
  vpc = true
}

########################
# DATABASE
########################
# Database Subnet A
resource "aws_subnet" "db-subnet-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.deploy_name}-DB-subnet-A"
  }
}
 
# Database Subnet B
resource "aws_subnet" "db-subnet-b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.deploy_name}-DB-subnet-B"
  }
}

