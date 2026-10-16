provider "aws" {
  region = "us-west-1"
}

resource "aws_security_group" "allow_web_traffic"{
    name= "allow traffic"
    description = "Allow inbound traffic on port 80"

    ingress{
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    ingress{
        description ="http"
        from_port = 80
        to_port =80
        protocol ="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        #Allow outbound traffic to anywhere
        from_port = 0
        to_port =0
        protocol ="-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Generate a private key using Terraform

resource "tls_private_key" "my-key-pair" {
    algorithm = "RSA"
    rsa_bits = 4096
  
}
# Create AWS Key Pair

resource "aws_key_pair" "my-key-pair" {
    key_name = "my-key-pair"
    public_key = tls_private_key.my-key-pair.public_key_openssh
}

# Save the private key locally

resource "local_file" "private_key"{
    content = tls_private_key.my-key-pair.private_key_pem
    filename = "${path.module}/my-key-pair.pem"
    file_permission = "0600"
}


resource "aws_instance" "test-webserver" {
    ami= var.ami_value
    instance_type = var.instance_type_value
   vpc_security_group_ids = [aws_security_group.allow_web_traffic.id]

    #ssh key pair name
    key_name = "my-key-pair"

    user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install nginx -y
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "<h1>Welcome to Terraform</h1>" > /var/www/html/index.html
            EOF

associate_public_ip_address = true


}
