terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    bucket = "tcb-build-ecs"
    key    = "tcb-build-ecs"
    region = "us-east-1"
  }

  required_version = ">= 1.0.4"
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "tcb_build-ec2" {
  ami                           = "ami-08b2293fdd2deba2a"
  instance_type                 = "a1.medium"
  key_name                      = "id_rsa"
  associate_public_ip_address   = true

  tags = {
    Name = "tcb-build-ecs"
  }

  # provisioner "remote-exec" {
  #   inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

  #   connection {
  #     host        = self.public_ip
  #     type        = "ssh"
  #     user        = "admin"
  #     private_key = file("id_rsa")
  #   }
  # }

  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u admin -i '${self.public_ip},' --private-key id_rsa ../provision/playbook.yaml"
  # }
}