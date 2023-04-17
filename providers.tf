terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-2"
  profile   = "Steves_Sandpit_1"
}