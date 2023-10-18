terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  # count = 2 // number os instances
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name = "terraform-aws-keys"
  vpc_security_group_ids = [aws_security_group.ssh-access.id]

  tags = {
    Name = "TerraformAWST2"
    # Name = "TerraformAWST2${count.index}"
  }
}

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  description = "access to ssh"
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["177.159.38.96/32"]
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}