# terraform project  
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
#   shared_config_files      = ["/home/ubuntu/.aws/config"]
#   shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
#   profile                  = krishna
# }

resource "aws_vpc" "my_vpc"{
    cidr_block ="192.168.0.0/16"
}

resource "aws_subnet" "public_subnet"{
    vpc_id ="aws_vpc.my_vpc.id"
    cidr_block ="192.168.0.1/24"
    availability_zone = "us_east_1a"
}
resource "aws_internet_gateway" "my_igw"{
vpc_id = aws_vpc.my_vpc.id


route{
    cidr_block ="0.0.0.0/0"
    gateway.id = "aws_internet_gateway.my_igw.id"
}
}
resource "aws_instance" "my_instance"{
region ="us-east-1"
ami = "ami-080e1f13689e07408"
instance_type = "t2.micro"
key_name = "varginia"
count = 4
}

resource "aws_instance" "my_instance"{
region ="us-east-1"
ami = ""
instance_type = "t2.micro"
key_name = "mumbai"
count = 1
tags = {
        Name ="ansible-server"
        }

 user_data = <<-EOF
 sudo apt update -y
 sudo apt install software-properties-common -y
 sudo apt add-repository ppa:ansible/ansible
 sudo apt update -y
 sudo apt install ansible -y
 sudo systemctl start ansible
 sudo systemctl enable ansible
 sudo systemctl status ansible
        EOF
}

