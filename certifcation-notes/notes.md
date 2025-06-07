# Terraform Associate Exam Guide

## creating resource conditinally using:

count statement

```bash
resource "aws_intance" "example"{
    count = var.create_insatnce ? 1: 0
    ami = "ami-12345"
    instance_type = "t2.micro"
}
```

## Remote exec provisioner

to execute command on remore machine using SSH

## remove files from Terraform state with out deleting resource

terraform state rm

## use dyanmic to dynamically generate the resources

```
variable "ingress_ports" {
  type    = list(number)
  default = [80, 443]
}

resource "aws_security_group" "example" {
  name = "dynamic-sg"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}   ]
}
```

## You can also provide backend configuration file in backend.hcl

```
# backend.hcl
bucket = "terraform-up-and-running-state"
region = "us-east-2"
dynamodb_table = "terraform-up-and-running-locks"
encrypt = true

# Partial configuration. The other settings (e.g., bucket,
region) will be
# passed in from a file via -backend-config arguments to
'terraform init'
terraform {
 backend "s3" {
 key = "example/terraform.tfstate"
 }
}

terraform init -backend-config=backend.hcl

```

## some of the lifecyle block in terraform

1. create_before_destroy - create new resources before destroy
2. prevent_destroy - accdental deletion
3. ignore changes - ignores changes to specified attribues:wq

## enable detailed logging

export TF_LOG=

## terraform taint vs terrafrom state rm

terraform taint - mark state for recreation (bad resources)  
terraform state rm - remove resource from terraform state so that terraform will stop tracking

## terraform proviser

local-exec: run shell command on local machine
remote-exec: run shell command on remote machine
file: copy files from local machine to remote machine

## lock provider versions

.terraform.lock.hcl

## list all the resources in current state file

terraform state list

## upgrade proivider plugins

terraform init --upgrade

## Module in terraform

### defining a module

It is just a folder having bunch of tf file, with variable and output

Those variable will act as input when calling

### calling a module

```sh
module <module_name> {
  source = <location of module> # can be registy or remote

  # pass variable here

}
```

### using the output from the module

```
module.<module_name>.<output_variable_name>
```
NOTE: you can only read out in parent module but not in siblig module.  

## Terraform data types
1. string  
2. number  
3. bool 
4. list(type) => ["a", "a", "c"] => "Homogeneous"
5. set(type) =>  ["a", "c"]
6. tuple(type) => ["alice", 30] => "Heterogenous"
7. map(type) =>  all values must be of the same type.
8. object({ attr1=type, attr2=type }) => all values of different type


## Terraform state mv
1. Rename a resource  
2. moving resouce from/to the module

No infrastructure changes: This only updates the state file, not the actual resources.  
Useful for refactoring: Helps when reorganizing code or adopting modules.  

## terraform plan -destroy
show summary of what will be destoyed if you do terraform destroy


## Terraform refresh
update state file from real infrasructure.
It only updates the state terraform already knows.
use terraform impoort to bring resources under terraform manangement.

For terraform import:  
```
1. add the resource block manually
resource "aws_s3_bucket" "my_bucket" {
  bucket = "your-bucket-name"
  # (add other configuration as needed)
}

2. Run import command to update the state file
terraform import <RESOURCE_TYPE>.<RESOURCE_NAME> <AWS_NAME>

```
## terraform plan -refresh-only
show the refresh plan and update the state

## Top 10 Terraform Commands with Common Flags

### 1. terraform init
- `-backend-config=PATH` : Specify backend config file.
- `-upgrade` : Upgrade modules and providers.
- `-reconfigure` : Reconfigure backend, ignoring saved config.
- `-input=false` : Disable interactive prompts.

### 2. terraform plan
- `-out=PATH` : Save the plan to a file.
- `-var 'NAME=VALUE'` : Set a variable value.
- `-var-file=FILENAME` : Load variable values from a file.
- `-target=RESOURCE` : Focus plan on a specific resource.
- `-refresh-only` : Only refresh state, do not propose changes.
- `-destroy` : Show what would be destroyed.
- `-input=false` : Disable interactive input.
- `-parallelism=N` : Limit concurrent operations.

### 3. terraform apply
- `PLAN_FILE` : Apply a saved plan file.
- `-auto-approve` : Skip interactive approval.
- `-var 'NAME=VALUE'` : Set a variable value.
- `-var-file=FILENAME` : Load variable values from a file.
- `-target=RESOURCE` : Apply only to a specific resource.
- `-input=false` : Disable interactive input.
- `-parallelism=N` : Limit concurrent operations.

### 4. terraform destroy
- `-auto-approve` : Skip approval prompt.
- `-var 'NAME=VALUE'` : Set a variable value.
- `-var-file=FILENAME` : Load variable values from a file.
- `-target=RESOURCE` : Destroy only a specific resource.
- `-input=false` : Disable interactive input.
- `-parallelism=N` : Limit concurrent operations.

### 5. terraform validate
- `-json` : Output validation results in JSON format.

### 6. terraform fmt
- `-recursive` : Format files recursively in subdirectories.
- `-check` : Check if files are formatted.
- `-diff` : Show differences.

### 7. terraform output
- `-json` : Output values in JSON format.
- `-state=PATH` : Use a specific state file.

### 8. terraform state
- `list` : List resources in state.
- `show ADDRESS` : Show details for a resource.
- `rm ADDRESS` : Remove a resource from state.
- `mv SOURCE DEST` : Move a resource in state.
- `pull` : Download latest state.
- `push` : Upload a local state file.

### 9. terraform import
- `-var 'NAME=VALUE'` : Set a variable value.
- `-var-file=FILENAME` : Load variable values from a file.
- `-input=false` : Disable interactive input.

### 10. terraform workspace
- `new NAME` : Create a new workspace.
- `select NAME` : Switch to a workspace.
- `list` : List all workspaces.
- `delete NAME` : Delete a workspace.