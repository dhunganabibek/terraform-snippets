provider "aws" {
  region  = "us-east-1"
  profile = "cloudguru"
}

# creating variable fr the port
variable "port" {
  description = "The port to be used for the web server"
  type        = number
  default     = 8080
}

# printing down the ip address of the instance
output "instance_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.vm.public_ip
}

# creating new aws ec2 instance
resource "aws_instance" "vm" {
  ami                         = "ami-0f1a6835595fb9246"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "my-ec2-instance"
  }
  user_data_replace_on_change = true
  user_data                   = <<-EOF
                #!/bin/bash
                echo "Hello, World!" >> index.xhtml
                nohup python3 -m http.server ${var.port} --bind 0.0.0.0 &
                EOF
}

# addding security group to allow http traffic
resource "aws_security_group" "instance_sg" {
  name = "instance_sg"
  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# adding auutoscaling group launch template
resource "aws_launch_template" "asg_launch_template" {
  image_id      = "ami-0f1a6835595fb9246"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Hello, World" > index.xhtml
    nohup busybox httpd -f -p ${var.port} &
  EOF
  )
}

# adding Autoscaling group
resource "aws_autoscaling_group" "asg-test" {
  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }
  min_size     = 1
  max_size     = 3
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  desired_capacity = 2
    tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
  
}