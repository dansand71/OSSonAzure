#!/bin/bash
echo "Download the demos from GIT and change ownership"
cd /source
sudo chown -R GBBOSSDemo /source/OSSonAzure/.

#SECTION FOR YOU TO CUSTOMIZE
echo "Please customize the line below to build your customized demo environment..."
echo "This should be run on the LINUX Utility server after the initial environment setup."

echo "Change the server names"
sudo grep -rl REPLACEME ./ --exclude step3-customizeDemos-on-jumpbox.sh | sudo xargs sed -i 's/REPLACEME/new-short-lowercase-new-value/g'

echo "Change the REGISTRY NAME"
sudo grep -rl REPLACE-REGISTRY-NAME ./ --exclude step3-customizeDemos-on-jumpbox.sh| sudo xargs sed -i 's/REPLACE-REGISTRY-NAME/new-registry-name-from-portal/g'

echo "Change the REGISTRY PASSWORD"
sudo grep -rl REPLACE-REGISTRY-PASSWOR ./ --exclude step3-customizeDemos-on-jumpbox.sh| sudo xargs sed -i 's/REPLACE-REGISTRY-PASSWORD/new-password-from-portal/g'

echo "Change the APP INSIGHT KEY "
sudo grep -rl REPLACE-APP-INSIGHTS-KEY ./ --exclude step3-customizeDemos-on-jumpbox.sh| sudo xargs sed -i 's/REPLACE-APP-INSIGHTS-KEY/new-app-insights-key-from-portal/g'

echo "Change the OMS Workspace"
sudo grep -rl REPLACE-OMS-WORKSPACE ./ --exclude step3-customizeDemos-on-jumpbox.sh| sudo xargs sed -i 's/REPLACE-OMS-WORKSPACE/new-oms-workspacekey-from-portal/g'

echo "Change the OMS Subscription ID"
sudo grep -rl REPLACE-OMS-SUBSCRIPTIONID ./ --exclude step3-customizeDemos-on-jumpbox.sh| sudo xargs sed -i 's/REPLACE-OMS-SUBSCRIPTIONID/new-oms-subscriptionkey-from-portal/g'

#Install and configure Ansible as needed and cleanup the download
sudo wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
sudo rpm -ivh epel-release-7-9.noarch.rpm
sudo yum -y install ansible
sudo rm -rf epel-release-7-9.noarch.rpm*.*

#Set Scripts as executable
sudo chmod +x /source/OSSonAzure/step3-customizeDemos-on-jumpbox.sh
sudo chmod +x /source/OSSonAzure/kubernetes/configK8S.sh
sudo chmod +x /source/OSSonAzure/kubernetes/refreshK8S.sh
sudo chmod +x /source/OSSonAzure/kubernetes/deploy.sh
sudo chmod +x /source/OSSonAzure/azscripts/newVM.sh

ansible-playbook -i /source/OSSonAzure/ansible/hosts /source/OSSonAzure/ansible/utili-server-configuration.yml -v
