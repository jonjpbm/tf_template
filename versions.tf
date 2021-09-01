# The minimum required Terraform and provider versions will be specified in versions.tf
# For example
/*
terraform {
  required_providers {
    #For example. Specifiying the AWS provider version
    aws = {
      source = "hashicorp/aws"
      version = "3.44.0"
    }
  }
  #Specified Terraform Version
  required_version = ">= 0.15.3"
}
*/
