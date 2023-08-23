ports         = [22, 80, 443, 3306, 27017]
image_id      = "ami-04e601abe3e1a910f" # could be used but automatic search has been already implemeneted 
instance_type = "t2.micro"
aws_region = "eu-central-1"
image_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"