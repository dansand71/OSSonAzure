#!/bin/bash
#This script is meant to be run on your initial environment LINUX CENTOS or UBUNTU setup machine

echo "Please customize the line below to build your customized scripts..."
sudo mkdir ./source
echo "Downloading the demos from GIT and change ownership"

#Install and configure GIT
if [ -f /etc/redhat-release ]; then
  sudo yum -y install git
fi

if [ -f /etc/lsb-release ]; then
  sudo apt-get install git
fi

cd ./source
sudo rm -rf ./source/OSSonAzure
sudo git clone https://github.com/dansand71/OSSonAzure
sudo chown -R GBBOSSDemo ./source/OSSonAzure/.

#CHANGE your VALUES HERE
echo "Change the server names"
sudo grep -rl VALUEOF-UNIQUE-SERVER-PREFIX ./source  | sudo xargs sed -i 's/VALUEOF-UNIQUE-SERVER-PREFIX/NEW-DATA-HERE/g'

echo "Change the REGISTRY NAuserME"
sudo grep -rl VALUEOF-REGISTRY-USER-NAME ./source | sudo xargs sed -i 's/VALUEOF-REGISTRY-USER-NAME/NEW-DATA-HERE/g'

echo "Change the STORAGE NAME"
sudo grep -rl VALUEOF-UNIQUE-STORAGE-ACCOUNT-PREFIX ./source | sudo xargs sed -i 's/VALUEOF-UNIQUE-STORAGE-ACCOUNT-PREFIX/NEW-DATA-HERE/g'


echo "Change the Registry Server"
sudo grep -rl VALUEOF-REGISTRY-SERVER-NAME ./source | sudo xargs sed -i 's/VALUEOF-REGISTRY-SERVER-NAME/NEW-DATA-HERE/g'


echo "Change the Registry password"
sudo grep -rl VALUEOF-REGISTRY-PASSWORD ./source | sudo xargs sed -i 's/VALUEOF-UNIQUE-STORAGE-ACCOUNT-PREFIX/VALUEOF-REGISTRY-PASSWORD/g'


echo "Change the OMS Workspace"
sudo grep -rl VALUEOF-REPLACE-OMS-WORKSPACE ./source | sudo xargs sed -i 's/VALUEOF-REPLACE-OMS-WORKSPACE/NEW-DATA-HERE/g'


echo "Change the OMS Key"
sudo grep -rl VALUEOF-REPLACE-OMS-PRIMARYKEY ./source | sudo xargs sed -i 's/VALUEOF-REPLACE-OMS-PRIMARYKEY/NEW-DATA-HERE/g'

echo "Change the App Insights Key"
sudo grep -rl VALUEOF-APPLICATION-INSIGHTS-KEY ./source | sudo xargs sed -i 's/VALUEOF-APPLICATION-INSIGHTS-KEY/NEW-DATA-HERE/g'


#Set Scripts as executable
sudo chmod +x ./source/OSSonAzure/step3-createAzureDemoEnvironment.sh