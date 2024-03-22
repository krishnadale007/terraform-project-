terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

provider "aws" {
  region = var.region
#shared_config_files      = ["/home/ubuntu/.aws/config"]
#    shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
#    profile                  = krishna
#  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.0.0/24" # Adjusted subnet CIDR block
  availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_instance" "my_instance" {
  ami           = "ami-080e1f13689e07408" # Example AMI, replace with appropriate AMI ID
  instance_type = "t2.micro"
  key_name      = "mumbai"
  count         = 4

  tags = {
    Name = "my_instance-${count.index}"
  }
}

resource "aws_instance" "ansible_server" {
  ami           = "ami-080e1f13689e07408" # Specify the appropriate AMI ID
  instance_type = "t2.micro"
  key_name      = "mumbai"
  count         = 1

  tags = {
    Name = "ansible-server"
  }

  user_data = <<-EOF
    sudo apt update -y
    sudo apt install software-properties-common -y
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible -y
    sudo systemctl start ansible
    sudo systemctl enable ansible
    sudo systemctl status ansible
  EOF
}

