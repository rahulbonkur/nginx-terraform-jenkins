terraform {
  backend "s3" {
    bucket         = "rahul-jenkins"
    key            = "portfolio/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
}
}
