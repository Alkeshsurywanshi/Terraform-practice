provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "alkesh" {
  instance_type = "t2.micro"
  ami = "ami-0fb110df4c5094d21" 
  
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "alkesh-terraform-state-1997"

}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
