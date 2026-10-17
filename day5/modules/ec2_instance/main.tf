provider "aws" {
    region = "us-west-1"
}

variable "ami_value" {
    description = "The ami value for the instance"
    
}

variable "instance_type_value" {
    description = "The instance type for the instance"
    
}

resource "aws_instance" "my-instance" {
    ami = var.ami_value
    instance_type = var.instance_type_value

    
}

