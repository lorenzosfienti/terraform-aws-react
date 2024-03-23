terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.26.0"
    }
  }
  required_version = ">= 0.14.9"

  # We store terraform terraform-aws-react-state.tfstate on s3 bucket "terraform-aws-react-state" in order to make it persistent and sharable.
  # https://www.terraform.io/docs/language/settings/backends/index.html 
  backend "s3" {
    profile = "lorenzosfienti"
    bucket  = "terraform-aws-react-state"
    key     = "terraform-aws-react.tfstate"
    region  = "us-east-1"
  }
}

# Configure default AWS Provider
provider "aws" {
  profile = "lorenzosfienti"
  region  = var.region

  default_tags {
    tags = {
      "project-url" = "https://github.com/lorenzosfienti/terraform-aws-react"
    }
  }
}