terraform {
  backend "s3" {
    bucket = "myprojectbucket-afonsosequeira"
    key    = "EKS/terraform.tfstate"
    region = "us-east-2"
  }
}