# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "bucketdenzel-testenumber3"
    dynamodb_table = "state-lock"
    key            = "us-east-1/renanzin27/ami/terraform.tfstate"
    region         = "us-east-1"
  }
}
