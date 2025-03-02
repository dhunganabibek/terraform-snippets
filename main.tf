provider "aws" {
  region = "us-east-1"
  profile = "cloudguru"
}

resource "aws_instance" "vm" {
  ami = "ami-0aa38b529e2e10b22"
  subnet_id = "subnet-0f8cf5fb423b9f55e"
  instance_type = "t2.micro"
  tags = {
    Name = "First VM created by Terraform"
  }
}


resource "local_file" "test" {
  content  = "Hello, World!"
  filename = "${path.module}/${var.filename}"
}

output "output-content" {
  value = "Hello, World!"
}

output "output-filename" {
  value = "hello"
}

