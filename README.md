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

## Use ADO pipeline for CI/CD
