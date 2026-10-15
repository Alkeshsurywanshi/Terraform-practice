terraform {
     backend "s3" {
       bucket         = "alkesh-terraform-state-1997"
       key            = "alkesh/terraform.tfstate"
       region         = "us-west-1" 
       encrypt        = true
       dynamodb_table = "terraform-lock"
     }
   }