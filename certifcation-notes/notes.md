# Terraform Associate Exam Guide

## creating resource conditinally using:
count statement  
```bash
resource "aws_intance" "example"{
    count = var.create_insatnce ? 1: 0
    ami = "ami-12345"
    instance_type = "t2.micro"
}
```