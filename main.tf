terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.45.0"
    }
  }
}


# aws_vpc.tf

# Create a VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-a"
  }
}

# Create a private subnet
resource "aws_subnet" "private-a" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-a"
  }
}

# security_group.tf

# Create a security group
resource "aws_security_group" "my-sg" {
  name        = "my-sg"
  description = "Security group for my resources"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg"
  }
} 

# aws_lb_listner.tf

# Create an ALB
resource "aws_lb" "my-alb" {
  name            = "my-alb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.my-sg.id]
  subnets         = [aws_subnet.public-a.id, aws_subnet.private-a.id]

  tags = {
    Name = "my-alb"
  }
}

