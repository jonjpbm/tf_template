# !!!! Generally !!!! this is where you would be creating resources
# and/or calling your modules to create those resources


# !!!! IF !!!! you are using the config file to handle different enviornmnets, you could use this partial backend config
# Partial backend configuration: https://www.terraform.io/docs/language/settings/backends/configuration.html#partial-configuration
# Otherwise this "terraform" block below would be in the backend.tf file but not both.
terraform {
  backend "s3" {
    encrypt = true
  }
}


/*
# Example
module "network" {
  source = "../modules/network"

  name = "${var.name}"

  cidr = "${var.cidr}"
  azs = "${var.azs}"
  public_subnets = "${var.public_subnets}"
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "v2.0.0"

  #...
}
*/
