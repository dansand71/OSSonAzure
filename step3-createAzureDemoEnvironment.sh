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
az storage account create -l eastus -n VALUEOF-UNIQUE-STORAGE-ACCOUNT-PREFIX-storage -g ossdemo-utility --sku Standard_LRS

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

#CREATE OSSDemo-Docker Public Ip and Load Balancer
echo 'Create public IP for Docker Demo Resource Group'
#az network public-ip create -g ossdemo-docker -n ossdemo-docker-publicIP -l eastus --dns-name VALUEOF-UNIQUE-STORAGE-ACCOUNT-PREFIX-docker
#az network lb create -g ossdemo-docker -n ossdemo-docker-publicLoadBalancer -l eastus --public-ip-address ossdemo-docker-publicIP
#az network lb address-pool create --lb-name ossdemo-docker-publicLoadBalancer--name ossdemo-docker-addresspool --resource-group ossdemo-docker

#CREATE UTILITY JUMPBOX SERVER
echo ""
echo 'Create CENTOS utility machine for RDP, Container BUILD and administration demos'
echo "--------------------------------------------"
az vm create -g 'ossdemo-utility' -n utility-VALUEOF-UNIQUE-SERVER-PREFIX-jumpbox \
        --public-ip-address-dns-name 'utility-VALUEOF-UNIQUE-SERVER-PREFIX-jumpbox' \
        --os-disk-name 'utility-VALUEOF-UNIQUE-SERVER-PREFIX-jumpbox-disk' \
        --image "OpenLogic:CentOS:7.2:latest" --os-type linux --nsg 'NSG-ossdemo-utility'  --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2 --admin-username GBBOSSDemo \
        --no-wait \
        --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222'


