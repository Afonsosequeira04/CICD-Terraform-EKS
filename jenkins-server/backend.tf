terraform {
  backend "s3" {
    bucket = "myprojectbucket-afonsosequeira"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-2"
  }
}