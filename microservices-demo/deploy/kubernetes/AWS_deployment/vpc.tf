resource "aws_default_vpc" "main" {
  tags = {
    Name = "main"
  }
}