resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "msk_subnet" {
  count             = 2 # Create two subnets
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_security_group" "msk_security_group" {
  name   = "msk_security_group"
  vpc_id = aws_vpc.msk_vpc.id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from anywhere for dev testing
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
