# cacloudstudio-infra

## Use Terraform to create VM
Under the virtual-machine directory is a Terraform module to create a VM resource on Microsoft Azure. Steps to do so:

1. Initialize terraform plugins, providers, and modules.
```bash
terraform init
```
2. Login to your Azure subscription using Azure CLI.
```bash
az login
```
3. Configure environment variable containing the appropriate subscription_id variables to be used.
```bash
export ARM_SUBSCRIPTION_ID="XXXXXXXXXXXXXXXXXXXXXX"
```
4. Create a terraform plan using the .tfvars file you created. The -var-file option designates a .tfvars file for use as variables, and the -out designates the name of the file to store your plan.
```bash
terraform plan -var-file=FILENAME.tfvars -out=FILENAME.tfplan
```
5. Apply the terraform plan.
```bash
terraform apply FILENAME.tfplan
```

## Use Ansible to install softwares

1. Configure environment variable containing the appropriate subscription_id variables to be used.
```bash
export AZURE_VM_IP="XXX.XXX.XXX.XXX"
export AZURE_VM_PASSWORD='XXXXXXXXXXXX' # Use of single quotes here is important because there is potential of password containing $, which will cause errors in shell if using "" instead of ''
export AZURE_VM_ADMINUSER="adminuser"
export PYTHON_PATH="/usr/bin/python3"
export DOMAIN="cacloudstudio.com"
export EMAIL="anna.xing@cacloudstudio.com"
```

2. Install sshpass program (required for ssh connection type with password)
```bash
brew install sshpass
```

3. Run Ansible playbook
```bash
ansible-playbook playbook.yml -i inventory.yaml --extra-vars "domain=$DOMAIN email=$EMAIL"
```

## How to Setup Terraform Cloud in ADO pipeline
1. Create a workspace in your Terraform account. Select CLI-Driven workflow.

2. Use command terraform login to authenticate into HCP Terraform (or follow instructions for credential block on the workspace website). You will be prompted to create a token and store it.
```bash
terraform login
```

3. After authentication, add this code block into the Terraform configuration files.
```bash
terraform { 
  cloud { 
    
    organization = "CaCloudStudio" 

    workspaces { 
      name = "Infra" 
    } 
  } 
}
```

## Use Docker to build image

## Use Helm to deploy kubernetes service

## Use ADO pipeline for CI/CD
