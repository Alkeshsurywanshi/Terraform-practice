provider "aws" {
    region = "us-west-1"
}


variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "ami_value" {
    default = "ami-0fb110df4c5094d21"
}

variable "instance_type_value" {
    default = "t2.micro"
}

resource "aws_key_pair" "my-key-pair" {
    key_name = "terraform-key-demo"
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))

}

resource "aws_vpc" "my-vpc" {
    cidr_block = var.cidr_block

}

resource "aws_subnet" "subnet1"{
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-west-1a"
    map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my-vpc.id

}

resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
}

resource "aws_route_table_association" "RTA1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.RT1.id

}

resource "aws_security_group" "my-sg"{
    name = "web"
    vpc_id = aws_vpc.my-vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol ="tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        
    }

    tags = {
        Name = "web-sg"
    }
}

    resource "aws_instance" "my-instance" {
        ami = var.ami_value
        instance_type = var.instance_type_value
        key_name = aws_key_pair.my-key-pair.key_name
        vpc_security_group_ids = [aws_security_group.my-sg.id]
        subnet_id = aws_subnet.subnet1.id

        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file(pathexpand("~/.ssh/id_rsa")) 
            host = self.public_ip
        }
    

     # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]
  }
}