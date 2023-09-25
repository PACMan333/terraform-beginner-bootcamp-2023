# Terraform Beginner Bootcamp 2023 - Week 0

- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Considerations with the Terraform CLI installation changes](#considerations-with-the-terraform-cli-installation-changes)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle](#gitpod-lifecycle)
- [Working with Env Vars](#working-with-env-vars)
  * [env command](#env-command)
  * [Settign and Unsetting Env Vars](#settign-and-unsetting-env-vars)
  * [Printing Vars](#printing-vars)
  * [Scoping of Env Vars](#scoping-of-env-vars)
  * [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraformn Basics](#terraformn-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
    + [Terraform Init](#terraform-init)
    + [Terraform Plan](#terraform-plan)
    + [Terraform Apply](#terraform-apply)
    + [Terraform Destroy](#terraform-destroy)
    + [Terraform Lock Files](#terraform-lock-files)
    + [Terraform State Files](#terraform-state-files)
    + [Terraform Directory](#terraform-directory)
- [Issues with Terraform Cloud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)

## Semantic Versioning

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org)

The general format:

**MAJOR.MINOR.PATCH,**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI installation changes

The Terraform CLI installation instructions have changed due to gpg keyring changes.  So needed to refer to the latest install CLI instructions via the Terraform Documentation and change the scripting for installation.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Considerations for Linux Distribution

This project is built against Ubunutu Linux.
Please consider checking your Linux Distribution and change it accordingly to your distribution needs.

[How to check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-coomand-line/)

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreication issues noticed that bash scripts steps were a considerable amount more code.  Decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allows us an easier way to debug and execute manually Terraform CLI install issues.
- This will allow for better portability for other projects that need to install Terraform CLI.

#### Shebang Considerations

A Shebang tells the bash script what program that will interpret the script.

https://en.wikipedia.org/wiki/Shebang_(Unix)


#### Execution Considerations

When executing the bash script we can use the `./` shorthand to execute the bash script.

eg. `./bin/insall_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permissions for the fix to be executable at the user mode level.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```



https://en.wikipedia.org/wiki/Chmod


## Gitpod Lifecycle

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.


https://www.gitpod.io/docs/configure/workspaces/tasks


## Working with Env Vars

### env command

We can list out all Environment Variables (Env Vars) using the `env` command

We can filter specific env vars using the grep command eg. `env | grep AWS_`

### Settign and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```

within a bash script we can set an env without writing an export eg.

```sh
#!/usr/bin/env bash

HELLO='world' 

echo $HELLO
```

### Printing Vars

we can print an env var using echo eg, `echo $HELLO`


### Scoping of Env Vars

When you open up new bash terminals in VS Code it will not be aware of env vars that you have set in another window.

If you want Env Vars to persist across all future bash terminals that are open, you need set env vars in your bash profile. eg. `.bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.


## AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)


We can check if our AWS credentials are configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that looks like this:

```json
{
    "UserId": "AIDAXWAX5I63BQNEXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraformer"
}
```

We'll need to generate AWS CLI credentials from IAM User in order for the user to use the AWS CLI.

## Terraformn Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform Registry whihc is located at [registry.terraform.io](https://registry.terraform.io)

- **Providers** is an interfacce to APIs that will allow you to create resources in terraform.
- **Modules** are a way to make large amounts of terraform code modular, portable and shareable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`


#### Terraform Init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we will use in the project.

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform.  Apply should prompt yes or no.

If we want to automatically approve an apply, we can provide the auto approve flag eg. `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy`

This will destroy resources.

You can also use the auto approve flag to skip the approve prompt eg. `terraform destroy --auto-approve`

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version control System (VCS) eg. GitHub


#### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure.

This file **should NOT be committed** to your Version control System (VCS).

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers.


## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will launch bash in a wisiwig view to generate a token.  However, it does not work as expected in GitPod VS Code in the browser.

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create and open the file here manually:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace with your token in the file):

```json
{
    "credentials": {
        "app.terraform.io": {
            "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
        }
    }
}
```

We have automated the workaround with the following bash script [bin/generate_ftrc_credentials](bin/generate_ftrc_credentials) 

