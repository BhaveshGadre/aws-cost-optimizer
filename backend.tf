terraform {
  backend "s3" {
    bucket = "costopt-tf-state-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "costopt-tf-lock-table"
    encrypt = true
  }
}