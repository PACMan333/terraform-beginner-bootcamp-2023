# Terraform Beginner Bootcamp 2023

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


### Github Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.


https://www.gitpod.io/docs/configure/workspaces/tasks