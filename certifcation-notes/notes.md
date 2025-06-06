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
## You can also provide backend configuration file in backend.hcl
```
# backend.hcl
bucket = "terraform-up-and-running-state"
region = "us-east-2"
dynamodb_table = "terraform-up-and-running-locks"
encrypt = true

# Partial configuration. The other settings (e.g., bucket,
region) will be
# passed in from a file via -backend-config arguments to
'terraform init'
terraform {
 backend "s3" {
 key = "example/terraform.tfstate"
 }
}

terraform init -backend-config=backend.hcl

```