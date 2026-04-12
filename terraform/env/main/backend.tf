terraform {
  backend "s3" {
    bucket         = "tfstate-willie"
    key            = "ecommerce-microservices-demo/eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}