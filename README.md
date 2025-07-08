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

## Use Ansible to install virtual machine for web service

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
cd ansible/web
ansible-playbook playbook.yml -i inventory.yaml --extra-vars "domain=$DOMAIN email=$EMAIL"
```

## Use Ansible to install virtual machine for ado self hosted agents
1. Configure environment variable containing the appropriate subscription_id variables to be used.
```bash
export AZURE_VM_IP="XXX.XXX.XXX.XXX"
export AZURE_VM_PASSWORD='XXXXXXXXXXXX' # Use of single quotes here is important because there is potential of password containing $, which will cause errors in shell if using "" instead of ''
export AZURE_VM_ADMINUSER="adminuser"
export PYTHON_PATH="/usr/bin/python3"
export ADO_PAT="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

2. Install sshpass program (required for ssh connection type with password)
```bash
brew install sshpass
```

3. Run Ansible playbook
```bash
cd ansible/ado
ansible-playbook playbook.yml -i inventory.yaml
```

## How to Setup HCP Terraform in ADO pipeline
1. Create a workspace in your Terraform account. Select CLI-Driven workflow.

2. We will be using HCP Terraform only to store state files that Azure DevOps can access. Thus, we must set the workspace's execution mode to "Local". You can find this option under "General" in the workspace settings.

3. Insert this code block into the Terraform configuration files.
```bash
terraform { 
  cloud { 
    
    organization = "Org Name" # make sure they match, case sensitive!

    workspaces { 
      name = "Workspace Name" 
    } 
  } 
}
```

4. Create a default azure-pipelines.yml template. Install necessary packages (i.e Terraform, curl, infra repo, etc). Remember to add to PATH. Example script below
```BASH
curl -# -L https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip -o terraform.zip
unzip terraform.zip

mkdir $HOME/bin/
mv ./terraform $HOME/bin/
echo "##vso[task.prependpath]$HOME/bin"
```

5. In HCP Terraform, create a Team-wide API token for authentication inside CI/CD Pipeline. Make sure it contains proper permissions to plan, apply, and store state files.

6. Inject the token as an environment variable into the pipeline. To do so, go to Azure DevOps, select the designated pipeline, then click Edit -> Variables. Add the token value into the pipeline as a secret value.

7. Now, in any stage where access to this environment variable is necessary, use the env property and associate the token with the name TF_TOKEN_app_terraform_io.
```BASH
env:
  TF_TOKEN_app_terraform_io: $(TERRAFORM_TOKEN)
```

8. You can then execute any Terraform script/task in the ADO agent pool through this token.

## Use Docker to build image

## Use Helm to deploy kubernetes service

## Use ADO pipeline for CI/CD
