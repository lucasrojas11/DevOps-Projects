terraform {
  backend "s3"  {
    bucket  = "s3-bucket" # replace with your actual bucket S3 name
    key     = "EKS/terraform.tfstate"
    region  = "us-east-1" #change your region
  }
}
