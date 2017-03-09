#!/bin/bash
echo "Please be sure to login to Azure prior to running this script with az login."

echo 'Use a particular subscription  - you should modify this for your environment if needed.'
#az account set --subscription "Microsoft Azure Internal Consumption"

#BUILD RESOURCE GROUPS
echo ""
echo "BUILD RESOURCE GROUPS"
echo "--------------------------------------------"
echo 'Create docker-demo resource group'
az group create --name ossdemo-docker --location eastus
echo 'Create docker-linux-paas-demo resource group'
az group create --name ossdemo-docker-linux-paas --location eastus
echo 'create kubernetes-demo resource group'
az group create --name ossdemo-kubernetes --location eastus
echo 'create utility resource group'
az group create --name ossdemo-utility --location eastus

#BUILD STORAGE ACCOUNTS
echo ""
echo "BUILD STORAGE ACCOUNTS"
echo "--------------------------------------------"
echo "Create Utility Storage account - you may need to change this in case there is a conflict"
echo "this is used in VM Create (Diagnostics storage) and Azure Registry"
az storage account create -l eastus -n UNIQUE-STORAGE-ACCOUNT-PREFIX-storage -g ossdemo-utility --sku Standard_LRS

#BUILD NETWORKS SECURTIY GROUPS and RULES
echo ""
echo "BUILD NETWORKS SECURTIY GROUPS and RULES"
echo "--------------------------------------------"
echo 'Network Security Group for utility Resource Group'
az network nsg create --resource-group ossdemo-utility --name NSG-ossdemo-utility --location eastus
echo 'Network Security Group for docker-demo Resource Group'
az network nsg create --resource-group ossdemo-docker --name NSG-ossdemo-docker --location eastus
echo 'Network Security Group for kubernetes-demo Resource Group'
az network nsg create --resource-group ossdemo-kubernetes --name NSG-ossdemo-k8s --location eastus
echo 'Allow RDP inbound to Utility'
az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name rdp-rule --access Allow --protocol Tcp --direction Inbound --priority 100 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 3389
echo 'Allow SSH inbound to Utility'
az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name ssh-rule --access Allow --protocol Tcp --direction Inbound --priority 110 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 22
echo 'Allow SSH inbound to docker-demo'
az network nsg rule create --resource-group ossdemo-docker --nsg-name NSG-ossdemo-docker --name ssh-rule --access Allow --protocol Tcp --direction Inbound --priority 100 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 22
echo 'Allow HTTP inbound to docker-demo'
az network nsg rule create --resource-group ossdemo-docker --nsg-name NSG-ossdemo-docker --name http-rule --access Allow --protocol Tcp --direction Inbound --priority 120 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 80
echo 'Allow SSH inbound to kubernetes-demo'
az network nsg rule create --resource-group ossdemo-kubernetes --nsg-name NSG-ossdemo-k8s --name ssh-rule --access Allow --protocol Tcp --direction Inbound --priority 100 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 22
echo 'Create Availability set for docker-demo environment'
az vm availability-set create -n ossdemo-docker-availabilityset -g ossdemo-docker --platform-update-domain-count 5 --platform-fault-domain-count 2

#CREATE AZURE REGISTRY
echo ""
echo "Create Azure Registry - this will be used to host the docker containers.  Working on a bug where this isnt allowed inside my VS Enterprise Subscription."
echo "--------------------------------------------"
echo " navigate to the Utility resource group.  Name the registry - gbbossdemoregistry"
az component update --add acr
az acr create -n REPLACE-REGISTRY-NAME -g ossdemo-utility -l eastus --storage-account-name UNIQUE-STORAGE-ACCOUNT-PREFIX-storage --admin-enabled true

#CREATE UTILITY JUMPBOX SERVER
echo ""
echo 'Create CENTOS utility machine for RDP, Container BUILD and administration demos'
echo "--------------------------------------------"
az vm create -g 'ossdemo-utility' -n utility-UNIQUE-SERVER-PREFIX-jumpbox --public-ip-address-dns-name 'utility-UNIQUE-SERVER-PREFIX-jumpbox' --os-disk-name 'utility-UNIQUE-SERVER-PREFIX-jumpbox-disk' \
        --image "OpenLogic:CentOS:7.2:latest" --os-type linux --nsg 'NSG-ossdemo-utility'  --storage-sku 'Premium_LRS' --size Standard_DS2_v2 --admin-username GBBOSSDemo \
        --no-wait --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222'


##TO-DO - TURN on Diagnostics as well as POWER-OFF TIMES
#az vm boot-diagnostics enable -n centos-utility -g utility

#CREATE KUBERNETES CLUSTER
echo ""
echo 'Create Kubernetes cluster for K8S Demo'
echo "--------------------------------------------"
echo "Attempting to install the kubernetes client within the Azure CLI tools.  This can fail.  Try to resolve and re-run: sudo az acs kubernetes install-cli"
sudo az acs kubernetes install-cli
echo "CREATE K8S Cluster"
az acs create --orchestrator-type=kubernetes --resource-group=ossdemo-kubernetes --name=ossdemo-k8s-REPLACEME --dns-prefix=ossdemo-k8s-REPLACEME --admin-username GBBOSSDemo --master-count 1 --ssh-key-value='ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222'