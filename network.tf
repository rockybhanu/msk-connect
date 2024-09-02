resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id
}

# Public subnets for MSK Cluster
resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.msk_vpc.id
  cidr_block              = "10.0.1${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

# Private subnets for MSK Connect
resource "aws_subnet" "private_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.msk_vpc.id
  cidr_block              = "10.0.2${count.index}.0/24" # Adjusted to avoid conflict
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.msk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.msk_igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
