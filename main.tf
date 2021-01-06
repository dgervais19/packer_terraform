# which is the required cloud provider?
# Aws as we have our amis on aws

provider "aws" {

        region = "eu-west-1"

}

resource "aws_instance" "nodejs_instance"{
 
         ami = "ami-0ef44873e50114086"
         instance_type = "t2.micro"
         associate_public_ip_address = true
         tags = {

             Name = "eng74_Donovan_nodejs_terra"

      }
         key_name = "eng74.donovan.aws.key"
}
