output "public_ip" {
    description = "Public IP of the web server"
    value = aws_instance.test-webserver.public_ip
  
}

output "web_url" {
    description = "URL of the web server"
    value = "http://${aws_instance.test-webserver.public_ip}"
}

output "instance_id" {
    description = "ID of the web server instance"
    value = aws_instance.test-webserver.id
}