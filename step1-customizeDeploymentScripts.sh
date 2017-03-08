#!/bin/bash
#This script is meant to be run on your initial environment LINUX CENTOS or UBUNTU setup machine

echo "Please customize the line below to build your customized scripts..."
mkdir /source
echo "Downloading the demos from GIT and change ownership"

#Install and configure GIT
if [ -f /etc/redhat-release ]; then
  sudo yum -y install git
fi

if [ -f /etc/lsb-release ]; then
  sudo apt-get install git
fi

sudo mkdir /source
cd /source
sudo rm -rf /source/OSSonAzure
sudo git clone https://github.com/dansand71/OSSonAzure

#CHANGE your VALUES HERE
echo "Change the server names"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACEME/new-short-lowercase-new-value/g'

echo "Change the REGISTRY NAME"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACE-REGISTRY-NAME/new-registry-name-from-portal/g'

#Set Scripts as executable
sudo chmod +x /source/OSSonAzure/step1-customizeDeployemntScripts.sh
sudo chmod +x /source/OSSonAzure/step2-createAzureDemoEnvironment.sh