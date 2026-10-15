provider "aws" {
    region = "us-west-1"
  
}

module "ec2_instance" {
 source = "./module/ec2_instance"
 ami_value = ""
 instance_type_value = ""
}