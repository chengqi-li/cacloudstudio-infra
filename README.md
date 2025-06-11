# cacloudstudio-infra

## Use Terraform to create VM
Under the virtual-machine directory is a Terraform module to create a VM resource on Microsoft Azure. Steps to do so:

1. Ensure you are under the virtual-machine directory.
```bash
cd virtual-machine
```
2. Initialize terraform plugins, providers, and modules.
```bash
terraform init
```
3. Login on the CLI to your Azure subscription using Azure CLI.
```bash
az login
```
4. Create a terraform plan for your resources. Here, be sure to include your own .tfvars file with subscription and tenant ID variables inside. The -var-file option designates a .tfvars file for use as variables, and the -out designates the name of the file to store your plan.
```bash
terraform plan -var-file=FILENAME.tfvars -out=FILENAME.tfplan
```
5. Apply the terraform plan.
```bash
terraform apply FILENAME.tfplan
```