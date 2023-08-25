
resource "aws_security_group" "k8s-security-group" {
  name        = "micro-k8s-security-group"
  description = "allow all internal traffic, ssh, http to let worker and slave nodes to setup communication"
  
    dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      description      = "TLS from VPC"
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  ingress {
    from_port   = 10248
    to_port     = 10260
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6784
    to_port     = 6784
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "securityGroupDetails" {
  value = "security group id ${aws_security_group.k8s-security-group.id}"
}
output "vpc details " {
  value = "vpc is  ${aws_security_group.k8s-security-group.vpc}"
}
