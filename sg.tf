resource "aws_security_group" "msk_security_group" {
  name   = "msk_security_group"
  vpc_id = aws_vpc.msk_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from the specific IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}
