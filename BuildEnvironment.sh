#!/bin/bash
#This script is meant to be run on your initial environment LINUX CENTOS or UBUNTU setup machine

#Install AZ Client - can we check if it is already installed?
curl -L https://aka.ms/InstallAzureCli | bash 

sudo mkdir /source

#Install GIT - can we check if it is already installed?
#Install and configure GIT
if [ -f /etc/redhat-release ]; then
  sudo yum -y install git
fi

if [ -f /etc/lsb-release ]; then
  sudo apt-get install git
fi

#Remove existing infra & reset
cd /source
sudo rm -rf /source/OSSonAzure
sudo git clone https://github.com/dansand71/OSSonAzure
sudo chown -R GBBOSSDemo /source/OSSonAzure/.


#Check if we are logged in - if 'az group list' returns "Please run 'az login' to setup account."
# run az login
echo "Azure Login"
az login

#If they type anything then try and change subscrition to that value.  If blank skip...
echo "Change Azure Subscription to:"
read azSubscriptionName
if [ -z azSubscriptionName ]; then
  az account set --subscription "Microsoft Azure Internal Consumption"
fi


# Check the validity of the name (no dashes, spaces, less than 8 char, no special chars etc..)
# Can we set a Enviro variable so if you want to rerun it is here and set by default?
echo "Please enter your unique server prefix: (Jumpbox server will become:'utility-PREFIX-jumpbox')"
echo "  Note - values should be lowercase and less than 8 characters.')"
read serverPrefix

# Check the validity of the name (no dashes, spaces, less than 8 char, no special chars etc..)"
# Can we set a Enviro variable so if you want to rerun it is here and set by default?
echo "Please enter your unique storage prefix: (Storage Account will become: 'PREFIX-storage'')"
echo "  Note - values should be lowercase and less than 8 characters.')"
read storagePrefix


#BUILD RESOURCE GROUPS
echo ""
echo "BUILDING RESOURCE GROUPS"
echo "--------------------------------------------"
az group create --name ossdemo-kubernetes --location eastus
echo 'create utility resource group'
az group create --name ossdemo-utility --location eastus

#BUILD STORAGE ACCOUNTS
echo ""
echo "BUILDING STORAGE ACCOUNTS"
echo "--------------------------------------------"
echo "Create Utility Storage account - you may need to change this in case there is a conflict"
echo "this is used in VM Create (Diagnostics storage) and Azure Registry"
az storage account create -l eastus -n $storagePrefix-storage -g ossdemo-utility --sku Standard_LRS

#BUILD NETWORKS SECURTIY GROUPS and RULES
echo ""
echo "BUILDING NETWORKS SECURTIY GROUPS and RULES"
echo "--------------------------------------------"
echo 'Network Security Group for utility Resource Group'
az network nsg create --resource-group ossdemo-utility --name NSG-ossdemo-utility --location eastus
echo 'Allow RDP inbound to Utility'
az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name rdp-rule --access Allow --protocol Tcp --direction Inbound --priority 100 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 3389
echo 'Allow SSH inbound to Utility'
az network nsg rule create --resource-group ossdemo-utility --nsg-name NSG-ossdemo-utility --name ssh-rule --access Allow --protocol Tcp --direction Inbound --priority 110 --source-address-prefix Internet --source-port-range "*" --destination-address-prefix "*" --destination-port-range 22

#CREATE UTILITY JUMPBOX SERVER
echo ""
echo 'Creating CENTOS JUMPBOX utility machine for RDP and ssh'
echo "--------------------------------------------"
az vm create -g 'ossdemo-utility' -n utility-$serverPrefix-jumpbox \
        --public-ip-address-dns-name 'utility-$serverPrefix-jumpbox' \
        --os-disk-name 'utility-$serverPrefix-jumpbox-disk' \
        --image "OpenLogic:CentOS:7.2:latest" --os-type linux --nsg 'NSG-ossdemo-utility'  --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2 --admin-username GBBOSSDemo \
        --no-wait \
        --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222'