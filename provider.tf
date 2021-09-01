# So here is where you would configure the particular provider for your script
# Do not get this confused with the version.tf file with states what providers 
# should be used and what is used for running the terraform code
#Examples

#AWS
provider "aws" {
  default_tags {
    tags = {
      managed-by = "terraform"
      owner      = "sre"
      source     = "https://github.com/ihm-software/tf_base_domain_join"
    }
  }
}

#PagerDuty hehe you said duty
provider "pagerduty" {
  token = var.pagerduty_token
}

#NewRelic
provider "newrelic" {
  account_id = <Your Account ID>
  api_key = <Your Personal API Key>    # usually prefixed with 'NRAK'
  region = "US"                        # Valid regions are US and EU
}

#Digital Ocean
#provider "digitalocean" {
#  token = var.do_token
#}
