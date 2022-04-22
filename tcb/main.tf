terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
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

  tags = {
    Name = "tcb-build-ecs"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get upgrade
              EOF
}
