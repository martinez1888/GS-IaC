#VPC
resource "aws_vpc" "vpcgs" {
  cidr_block           = var.vpcgs_cidr
  enable_dns_hostnames = var.vpcgs_dns_hostnames

  tags = {
    Name = "vpcgs"
  }
}
#INTERNET GATEWAY
resource "aws_internet_gateway" "igw_vpcgs" {
  vpc_id = aws_vpc.vpcgs.id

  tags = {
    Name = "igw_vpcgs"
  }
}
#SUBNET
resource "aws_subnet" "sn_vpcgs_1a" {
  vpc_id                  = aws_vpc.vpcgs.id
  cidr_block              = var.sn_vpcgs_1a_cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = "us-east-1a"

  tags = {
    Name = "sn_vpcgs_1a"
  }
}

resource "aws_subnet" "sn_vpcgs_1c" {
  vpc_id                  = aws_vpc.vpcgs.id
  cidr_block              = var.sn_vpcgs_1c_cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = "us-east-1c"

  tags = {
    Name = "sn_vpcgs_1c"
  }
}

resource "aws_subnet" "sn_vpcgs_2a" {
  vpc_id            = aws_vpc.vpcgs.id
  cidr_block        = var.sn_vpcgs_2a_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn_vpcgs_2a"
  }
}

resource "aws_subnet" "sn_vpcgs_2c" {
  vpc_id            = aws_vpc.vpcgs.id
  cidr_block        = var.sn_vpcgs_2c_cidr
  availability_zone = "us-east-1c"

  tags = {
    Name = "sn_vpcgs_2c"
  }
}

resource "aws_subnet" "sn_vpcgs_3a" {
  vpc_id            = aws_vpc.vpcgs.id
  cidr_block        = var.sn_vpcgs_3a_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn_vpcgs_3a"
  }
}

resource "aws_subnet" "sn_vpcgs_3c" {
  vpc_id            = aws_vpc.vpcgs.id
  cidr_block        = var.sn_vpcgs_3c_cidr
  availability_zone = "us-east-1c"

  tags = {
    Name = "sn_vpcgs_3c"
  }
}

#ROUTE TABLE
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpcgs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_vpcgs.id
  }

  tags = {
    Name = "rt_public"
  }
}

resource "aws_route_table" "rt_priv1" {
  vpc_id = aws_vpc.vpcgs.id

  tags = {
    Name = "rt_priv1"
  }
}

resource "aws_route_table" "rt_priv2" {
  vpc_id = aws_vpc.vpcgs.id

  tags = {
    Name = "rt_priv2"
  }
}

#SUBNET ASSOCIATION
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sn_vpcgs_1a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.sn_vpcgs_1c.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.sn_vpcgs_2a.id
  route_table_id = aws_route_table.rt_priv1.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.sn_vpcgs_2c.id
  route_table_id = aws_route_table.rt_priv1.id
}

resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.sn_vpcgs_3a.id
  route_table_id = aws_route_table.rt_priv2.id
}

resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.sn_vpcgs_3c.id
  route_table_id = aws_route_table.rt_priv1.id
}
