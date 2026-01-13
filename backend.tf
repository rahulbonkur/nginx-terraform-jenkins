terraform {
  backend "s3" {
    bucket         = "rahul-jenkins"
    key            = "portfolio/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"   # optional but recommended
  }
}
