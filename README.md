# tf_ihm_template

## Overview
This is an attempt to create a terraform template repository

This will be a combination to both good practices, common solutions
<br />
## Terraform File and Folder Structure
File name and structure and folder structure are very subjective and you can find many
examples of file name and structure.

While I will provide some references for structure below,
I think the big take-away is **consistency AND you must have a converstation with team to
form a consesus in order to acheive consistency and do your own research.**

Terraform file and folder structure references:
* https://www.terraform-best-practices.com/code-structure
* https://www.digitalocean.com/community/tutorials/how-to-structure-a-terraform-project
* https://www.terraform.io/docs/language/values/variables.html

Here is a suggestion of files to use and a suggestion of an explination for their use:

* `Main.tf` or `ResourceToCreate.tf` - This file typically has the code to create the resources in the provider, generally speaking. If it make sense, having some other terraform objects here in the code does not seem unreasonable.
* `variables.tf` - This file typically has the code to define the variables to be used in your code.
* `terraform.tfvars` - To set lots of variables, it is more convenient to specify their values in a variable definitions file. Note: terraform will automaticlly look for a file named exactly `terraform.tfvars` but it could be named anything with the `.tfvars` extension.
* `provider.tf` - This file will have any configurations that are needed for a given provider. Account IDs, region, secrets, etc...
* `versions.tf` - This file will have the code to specify, not only the terraform version you used to create your code but also the provider version.
* `backend.tf` - This file will have the code the specifys where you want to keep and store your terraform state file and/or lock file.
**NOTE**: The use of this file may change if one chooses to use [partial backend configuration](https://www.terraform.io/docs/backends/config.html#partial-configuration). It looks like this file is not needed if so.
* `README.md` - This is your standard readme.
<br />
## Handling Different Enviornments
This is an attempt to give suggestions on how to handle different enviornments in your terraform repository.

I have, more or less, found three approaches.

* Folders for each enviornment
* Workspaces
* Separate Configurations for Environments


### Folders for each enviornment
---
Simply create folders for each enviornment, prod,staging,qa,etc...

Each folder will have all of the typical files noted above and therefore would need to be called.

Pros - Simple

Cons - Manage "many" files

### Workspaces
---
* https://www.terraform.io/docs/language/state/workspaces.html

Pros - More complex

Cons - Less code

### Separate Configurations for Environments
---
* https://github.com/ozbillwang/terraform-best-practices#run-terraform-command-with-var-file

At the root of the repo, there is the `config` folder. This would only be used if you are using a partial backend config (see above).

This allows you to specify the backend and the tfvars to be used.

Pros - Less complex

Cons - Less code
<br />
## Pre-commit
I'm going to simply suggest using pre-commit here.
Pre-commit gives one the ability to automate some important but simple tasks when a commit is executed. The possibilities are almost endless depending on the effort.
* Clean up whitespace
* Do some linting
* Do some security checks
* Automate documentation
* etc...

https://medium.com/slalom-build/pre-commit-hooks-for-terraform-9356ee6db882
<br />
## Limitations
<br />
## Known Issues
<br />
## Usage

### How to use it locally
---

#### Install Terraform

* [Install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

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
<br />
## Github Actions Workflow YAMLs
So how you structure the code in the repo and how one handles multiple eviornments will directly effect your github action workflows.

Here in this template repo, I've created three different folders for each technique

* Folders for each enviornment
* Workspaces
* Separate Configurations for Environments

### Folders for each enviornment
---
This template has two basic workflows.

They are created around a pull request and a merge but I have seen different approaches.

* For a pull request --> This will be, more or less, everything but the `terraform apply` command. What you want to run/test against the code is up to you.

* For the merge --> This code will be more or less running the `terraform apply` 

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

There are AWS key enviornment variables that needed to be configured for the s3/dynamodb backend.

```bash
aws-access-key-id: ${{ secrets.<PUT_AWS_ACCESS_KEY_HERE>}}
aws-secret-access-key: ${{ secrets.<PUT_AWS_SECRET_KEY_HERE> }}
```

### Workspaces
---
TBD

### Separate Configurations for Environments
---
TBD
<br />
## Reference Terraform Module In Private Github Repo In Github Actions
As we potentially create internal Terraform modules for various providers,
one may reference these modues from with in their root Terraform module script.

There are different ways to reference the module code from within a Terraform
script but if one references using git, Terraform will perform a `git clone` which, in turn, uses SSH.
This is nothing new but if you want to use the Terraform commands from within the github workflow runner enviornment
and you're using a git reference for a given module, you will need to follow the doc below:

https://stackoverflow.com/a/67712889/10786944
<br />
Note
Notes here
<br />
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
