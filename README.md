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

7. Now, in Bash tasks where access to this environment variable is necessary, use the env property and associate the token with the name TF_TOKEN_app_terraform_io.
```BASH
env:
  TF_TOKEN_app_terraform_io: $(TERRAFORM_TOKEN)
```

8. You can then execute any Terraform script/task in the ADO agent pool through this token.

## Use Terraform Plan/Apply in ADO Pipeline
1. Create an Application Registration in Azure or Microsoft Entra. Then, create a client secret using **Certificates & Secrets** -> **New Client Secret**. Make sure to COPY the secret value and ID before leaving the page, as you will not have access to them again.

2. Inside the scope of your choice (i.e Subscription, Resource Group), add the newly created Application Registration to the Access Control (IAM). Select these options: **Role** --> **Privileged administrator roles** --> **Contributor**, **Members** --> **Select Members** --> type the *name* of your application registration. Then, click Review + assign.

3. Now, head to Azure Dev Ops portal. Inside your organization, create a new Service Connection by heading to **Project settings** --> **Service connections** --> **New service connection**. Select the following options: **Azure Resource Manager**, Identity: **App registration or managed identity (manual)**, Credential: **Secret**. Then, fill out the subscription ID, name, and authentication boxes with information from your previously created application registration.

4. After finishing creating the service connection, you can now reference it from the AzureCLI@2 task like below. To grant the pipeline access to the service connection, you will need to either add the pipeline in the Security options of the service connection, or run the pipeline and choose **Permit** once the error message **This pipeline needs permission to access a resource** shows up.
```bash
task: AzureCLI@2
  displayName: "Azure CLI Task"
  inputs:
    azureSubscription: "Name of Service Connection" 
```

5. The AzureCLI@2 task automatically sets the environment variables for client ID, tenant ID, and client secret. These will need to be passed into Terraform in future tasks, so we can use these scripts to export them. The subscription ID is not automatically set, so we will use `az account show` for that.
```Bash
ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo "##vso[task.setvariable variable=ARM_SUBSCRIPTION_ID]$ARM_SUBSCRIPTION_ID"

echo "##vso[task.setvariable variable=ARM_CLIENT_ID]$servicePrincipalId"
echo "##vso[task.setvariable variable=ARM_TENANT_ID]$tenantId"
```

6. It is not recommended to pass use these commands to set secrets. Thus, we will manually set the pipeline variable for client secret. Head to the pipeline, then go to **Edit** --> **Variables** and hit the plus sign next to the search bar. Enter in the variable name, and the client secret copied earlier as the value. Be sure to check the box that says "Keep this value secret".

7. In future tasks that require use of Terraform scripts, set the env: block like below. This will allow Terraform's Azurerm to automatically authenticate to your Azure subscription.
```bash
env:
  ARM_CLIENT_ID: $(ARM_CLIENT_ID)
  ARM_CLIENT_SECRET: $(SECRET_VARIABLE_NAME)
  ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
  ARM_TENANT_ID: $(ARM_TENANT_ID)
```
## Use Docker to build image

## Use Helm to deploy kubernetes service

## Use Kubernetes to Deploy Docker Image (Local)

1. First, provision an AKS cluster along with an Azure Container Registry resource.

2. Push docker images unto the ACR resource through Azure CLI.

3. Create a deployment.yaml manifest file. Under containers: block, there will be containers with image: blocks. Place the name of your ACR and address under the image: block, followed by your Docker image name and tag.
```bash
image: <name-of-registry>azurecr.io/<image-name>:<tag>
```

4. Create a service.yaml file, as well as other necessary yaml files (ex: ingress.yaml, hpa.yaml).

5. Use kubectl to apply your yaml manifest files: First, authenticate and configure local kube config.
```bash
az aks get-credentials --resource-group <rg-name> --name <aks-cluster-name>
```

6. Next, apply the manifest yamls.
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f others.yaml
```

## Configure ADO Pipeline to Deploy Docker Containers onto AKS

1. Similar to the ADO Pipeline for Terraform, a service connection as well as app registration on the Azure portal side will be needed. Assign the proper permissions to the app registration, such that the ADO pipeline connected to it will be able to access AKS. This can be done by giving the app registration Contributor role in the Subscription scope.

2. The pipeline will use Docker@2 and Kubernetes@1 task to push the docker image into a Container Registry and deploy into AKS. The task Docker@2 requires a Docker Registry service connection, in contrast to the previously used ARM (Azure Resource Manager) service connections. Kubernetes@1 task can use an ARM service connection.
```bash
- task: Docker@2
  inputs:
    command: buildAndPush
      containerRegistry: Docker Registry Connection

- task: Kubernetes@1
  displayName: Deploy to AKS
  inputs:
    connectionType: "Azure Resource Manager"
    azureSubscriptionEndpoint: ADO Pipeline Connection
    azureResourceGroup: <rg-name>
    kubernetesCluster: <cluster-name>
```

3. As such, the pipeline is connecting to the necessary resources and able to perform tasks such as kubectl apply and push Docker images to ACR.