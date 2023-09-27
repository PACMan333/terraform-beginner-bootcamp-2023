# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Git Tags

[How to Delete Local and Remote Tags in Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Local delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete a tag

```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```


## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
|
|--- main.tf              # everything else
|--- variables.tf         # stores the structure of input variables
|--- terraform.tfvars     # the data of variables we want to load into our terraform project
|--- providers.tf         # defines required providers and their configuration
|--- outputs.tf           # stores the output
|--- README.md            # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In terraform we can set two kinds odf variables:
- Environment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file 

We can set Terraform Cloud variables to be sensitive so they are not shown visibly in the UI.  

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_id="my-user_id"`

### var-file flag

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with -var-file:

```
terraform apply -var-file="testing.tfvars"
```

A variable definitions file uses the same basic syntax as Terraform language files, but consists only of variable name assignments:

```
image_id = "ami-abc123"
availability_zone_names = [
  "us-east-1a",
  "us-west-1c",
]
```


### terraform.tfvars

This is the default file to load in terraform variables in bulk.

### auto.tfvars

Terraform also automatically loads a number of variable definitions files if they are present:

- Files named exactly terraform.tfvars or terraform.tfvars.json.
- Any files with names ending in .auto.tfvars or .auto.tfvars.json.

Files whose names end with .json are parsed instead as JSON objects, with the root object properties corresponding to variable names:

```
{
  "image_id": "ami-abc123",
  "availability_zone_names": ["us-west-1a", "us-west-1c"]
}
```

### order of terraform variables

The above mechanisms for setting variables can be used together in any combination. If the same variable is assigned multiple values, Terraform uses the last value it finds, overriding any previous values. Note that the same variable cannot be assigned multiple values within a single source.

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)


**Important:**
```
In Terraform 0.12 and later, variables with map and object values behave the same way as other variables: the last value found overrides the previous values. This is a change from previous versions of Terraform, which would merge map values instead of overriding them.
```

## Dealing With Configuration Drift

## What happens if we lose our state file?

If you lose your statefile, you most likely will have to tear down all your cloud infrastructure manually.

You can use terraform import but it will not work for all cloud resources.  You need to check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)


### Fix Manual Configuration

If someone goes and deletes or modifies cloud resources manually through ClickOps.

If we run Terraform Plan it will attempt to put our infrastructure back into the expected state, fixing the Configuration Drift.

## Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Teraform Modules

[Terraform Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally developing modules, but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf file.

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Sources

Using the source we can import the module from various places eg.:
- locally
- GitHub
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```


## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be decprecated.  Often affecting providers.

## Working with Files in Terraform


### Fileexists function

This is a built in terraform function to check the existance of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

[File Exists Function](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5

[File MD5 Function](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}