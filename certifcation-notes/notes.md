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
## Remote exec provisioner
to execute command on remore machine using SSH

## remove files from Terraform state with out deleting resource
terraform state rm

## use dyanmic to dynamically generate the resources
```
variable "ingress_ports" {
  type    = list(number)
  default = [80, 443]
}

resource "aws_security_group" "example" {
  name = "dynamic-sg"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}   ]
}
```