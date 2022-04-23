terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }

  required_version = ">= 1.1.0"

  cloud {
    organization = "libre"

    workspaces {
      name = "tcb-build-ecs"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "tcb_build-ec2" {
  ami                         = "ami-08b2293fdd2deba2a"
  instance_type               = "a1.medium"
  key_name                    = "id_rsa"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tcb_build-ec2.id]

  tags = {
    Name = "tcb-build-ecs"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get upgrade
              EOF
}

resource "aws_security_group" "tcb_build-ec2" {
  name = "tcb_build-ec2-sg"
  ingress {
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
}