# which is the required cloud provider?
# Aws as we have our amis on aws


module myip {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

provider "aws" {

        region = "eu-west-1"

}

# Create the mongodb instance

resource "aws_instance" "mongodb_instance"{

         ami = "ami-022ea78f767c242a3"
         instance_type = "t2.micro"
         associate_public_ip_address = true
         key_name = "eng74.donovan.aws.key"
         tags = {

             Name = "eng74_Donovan_mongodb_terra"

      }
}

# Create app instance

resource "aws_instance" "nodejs_instance"{
 
         ami = "ami-0651ff04b9b983c9f"
         instance_type = "t2.micro"
         associate_public_ip_address = true
         key_name = "eng74.donovan.aws.key"
         tags = {

             Name = "eng74_Donovan_nodejs_terra"

      }
       # provisioner "remote-exec"{
		#    inline = [
		#	    "cd app/ && pm2 start app.js",
		#]
	#}

}

resource "aws_vpc" "vpc_terraform_dono" {
    cidr_block = "19.0.0.0/16"
    instance_tenancy = "default"
    
    tags = {
        Name = "eng74-Donovan-VPC-Terra"
    }
}

resource "aws_internet_gateway" "igw_vpc_dono" {
    vpc_id = aws_vpc.vpc_terraform_dono.id
    
    tags = {
        Name = "eng74-Donovan-IGW-Terra"
    }
}

resource "aws_subnet" "subnet-public" {
    vpc_id = aws_vpc.vpc_terraform_dono.id
    cidr_block = "19.0.1.0/24"
    
    tags = {
        Name = "eng74-Donovan-subnet-pub-Terra"
    }
}

# Create a SG

resource "aws_security_group" "sg_app" {
  name        = "public_sg_for_app_Donovan"
  description = "allows traffic to app"
  vpc_id      = aws_vpc.vpc_terraform_dono.id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port 3000 for my ip"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["${module.myip.address}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eng74_Dono_sg_app_terraform"
  }
}
