# tf_ihm_template

## Overview

Basic Terraform Template repository


<https://github.com/ozbillwang/terraform-best-practices>

### Terraform File and Folder Structure

File name and structure and folder structure are very subjective and you can find many
examples of file name and structure.

While I will provide some references for structure below,
I think the big take-away is **consistency AND you must have a converstation with team to
form a consesus in order to acheive consistency and do your own research.**

Terraform file and folder structure references:

* <https://www.terraform-best-practices.com/code-structure>
* <https://www.digitalocean.com/community/tutorials/how-to-structure-a-terraform-project>
* <https://www.hashicorp.com/blog/structuring-hashicorp-terraform-configuration-for-production>
* <https://www.terraform.io/docs/cloud/workspaces/configurations.html>
* <https://github.com/AustinCloudGuru/terraform-skeleton>

## Limitations

## Known Issues

## Usage

### How to use it locally

#### Install Terraform

* [Install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

This template has a `main.tf` with only the partial backend configuration

#### Handing Different Enviornmenets

##### (Optional) Having enviornment folders
```bash
mkdir prod
mkdir dev
```
Very simple approach. Using this structure in github action workflows is noted below

##### (Optional) Run terraform command with var-file using config folder

```bash
$ cat config/dev.tfvars

name = "dev-stack"
s3_terraform_bucket = "dev-stack-terraform"
tag_team_name = "hello-world"

$ terraform plan -var-file=config/dev.tfvars
```

With `var-file`, you can easily manage environment (dev/stag/uat/prod) variables.

With `var-file`, you avoid running terraform with long list of key-value pairs ( `-var foo=bar` )

#### Enable version control on terraform state files bucket

Always set backend to s3 and enable version control on this bucket.

[s3-backend](s3-backend) to create s3 bucket and dynamodb table to use as terraform backend.

#### Manage S3 backend for tfstate files

Terraform doesn't support [Interpolated variables in terraform backend config](https://github.com/hashicorp/terraform/pull/12067), normally you write a seperate script to define s3 backend bucket name for different environments, but I recommend to hard code it directly as below. This way is called as [partial configuration](https://www.terraform.io/docs/backends/config.html#partial-configuration)

Add below code in terraform configuration files.

```bash
$ cat main.tf

terraform {
  backend "s3" {
    encrypt = true
  }
}
```

Define backend variables for particular environment

```bash
$ cat config/backend-dev.conf
bucket  = "<account_id>-terraform-states"
key     = "development/service-name.tfstate"
encrypt = true
region  = "ap-southeast-2"
dynamodb_table = "terraform-lock"
```

#### Notes on S3

* `bucket` - s3 bucket name, has to be globally unique.
* `key` - Set some meaningful names for different services and applications, such as vpc.tfstate, application_name.tfstate, etc
* `dynamodb_table` - optional when you want to enable [State Locking](https://www.terraform.io/docs/state/locking.html)

After you set `config/backend-dev.conf` and `config/dev.tfvars` properly (for each environment). You can easily run terraform as below:

```bash
env=dev
terraform get -update=true
terraform init -backend-config=config/backend-${env}.conf
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars
```

If you encountered any unexpected issues, delete the cache folder, and try again.

```bash
rm -rf .terraform
```

#### Install Pre-commit

* [Install pre-commit](https://pre-commit.com/#install)

Install pre-commit using brew:

`brew install pre-commit`

Then run `pre-commit` install to set up the git hook scripts

```bash
$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

Now pre-commit will run automatically on git commit!

  There is a `.pre-commit-config.yaml` file in this template repo.
  It does a number of things by default:

* Looks for trailing whitespace, end of file, checks yaml, and added large files
* Looks for and does terraform checks. fmt, security, and linting
* Lastly, it attempts to make some basic documentation using [terraform-docs](https://github.com/terraform-docs/terraform-docs)

#### Github Actions Workflow YAMLs

There is a `github_action_workflows` folder with two files:

* `terraform-apply.yaml`
  * As the name implies, attempts to deploy terraform when code is merged with master branch

* `terraform-pull-request.yaml`
  * Does a number of things:
    * Security Scan
    * Terraform init
    * Terraform plan
    * Terraform linting
    * Adds plan output to comments in pull request

Both workflows incorporate an action that will execute in a particular enviornment folder based on the files that have been detected as changed.
In this template, there is a `dev`and a `prod` folder and these are referenced in the workflow YAMLs.

<https://github.com/dorny/paths-filter>

Now, once you have created a new repo based off of this one, you have to modify these workflow YAML files (see below) and then move them to `.github/workflows`.

There are AWS key enviornment variables in the workfow that are needed to be configured for the s3/dynamodb backend.

```bash
aws-access-key-id: ${{ secrets.<PUT_AWS_ACCESS_KEY_HERE>}}
aws-secret-access-key: ${{ secrets.<PUT_AWS_SECRET_KEY_HERE> }}
```

#### Reference Terraform Module In Private Github Repo In Github Actions

As we potentially create internal Terraform modules for various providers,
one may reference these modues from with in their root Terraform module script.

There are different ways to reference the module code from within a Terraform
script but if one references using git, Terraform will perform a `git clone` which, in turn, uses SSH.
This is nothing new but if you want to use the Terraform commands from within the github workflow runner enviornment
and you're using a git reference for a given module, you will need to follow the doc below:

<https://ihm-it.atlassian.net/wiki/spaces/SRE/pages/2219114515/Reference+Terraform+Module+In+Private+Github+Repo+In+Github+Actions>

## Note

Notes here

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
