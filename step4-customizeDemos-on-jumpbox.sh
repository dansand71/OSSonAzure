#!/bin/bash
echo "Customize the demos on the local jumpbox"
cd /source
chmod +x /source/OSSonAzure/step2-buildSetupScripts.sh 
sudo sh /source/OSSonAzure/step2-buildSetupScripts.sh

#Move the RSA key over and mark it secure
sudo cat /source/OSSonAzure/ssh-keys/id_rsa > ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa

#Fix the ability to not check if we have seen this machine before warnings in Ansible
sudo echo "export ANSIBLE_HOST_KEY_CHECKING=false" >> ~/.bashrc

#Run the configuration for the JUMPBOX
ansible-playbook -i /source/OSSonAzure/ansible/hosts /source/OSSonAzure/ansible/utility-server-configuration.yml -v
