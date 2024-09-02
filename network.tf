resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.msk_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true # Public subnet for NAT Gateway
}

resource "aws_subnet" "private_subnet" {
  count                   = 2 # Two private subnets for MSK and MSK Connect
  vpc_id                  = aws_vpc.msk_vpc.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false # Disable public IP assignment
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.msk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.msk_igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

data "aws_availability_zones" "available" {
  state = "available"
}