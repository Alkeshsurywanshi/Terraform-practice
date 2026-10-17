provider "aws" {
    region = "us-west-1"
}

variable "ami_value" {

    description = "The ami value for instance"
}

variable "instance_type_value" {
    description = "The instance type for the instance"
    type = map(string)


default = {
    "dev" = "t2.micro"
    "stage" = "t2.small"
    "prod" = "t2.medium"
    }
}


module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_value = var.ami_value
    instance_type_value = lookup(var.instance_type_value, terraform.workspace, "t2.micro")
}
