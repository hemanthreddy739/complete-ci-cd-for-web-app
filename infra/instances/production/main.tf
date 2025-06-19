terraform {
  backend "remote" {
    organization = "cloud-matrix"

    workspaces {
      name = "production"
    }
  }

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or a specific version like "5.30.0"
    }
  }
  required_version = "~> 1.5"

}

provider "aws" {
  region  = "ap-south-2"
}

variable "production_public_key" {
  description = "Production environment public key value"
  type        = string
}

variable "base_ami_id" {
  description = "Base AMI ID"
  type        = string
}

resource "aws_key_pair" "production_key" {
  key_name   = "production-key"
  public_key = var.production_public_key

  tags = {
    "Name" = "production_public_key"
  }
}

resource "aws_instance" "production_cicd_demo" {
  ami                    = var.base_ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-0a4716d54b6740619"]
  key_name               = aws_key_pair.production_key.key_name

  tags = {
    "Name" = "production_cicd_demo"
  }
}

output "production_dns" {
  value = aws_instance.production_cicd_demo.public_dns
}
