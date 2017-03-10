#!/bin/bash
echo "Customize the demos on the local jumpbox"
cd /source
sudo chmod +x /source/OSSonAzure/step2-buildSetupScripts.sh 
sudo /source/OSSonAzure/step2-buildSetupScripts.sh

#Setup demos for execution
sudo chmod +x /source/OSSonAzure/appdev-demos/setupDemo1.sh 

#Move the RSA key over and mark it secure
sudo cat /source/OSSonAzure/ssh-keys/id_rsa > ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa

#Fix the ability to not check if we have seen this machine before warnings in Ansible
sudo echo "export ANSIBLE_HOST_KEY_CHECKING=false" >> ~/.bashrc

#Install Ansible
sudo wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
sudo rpm -ivh epel-release-7-9.noarch.rpm
sudo yum install ansible -y


#Run the configuration for the JUMPBOX
ansible-playbook -i /source/OSSonAzure/ansible/hosts /source/OSSonAzure/ansible/utility-server-configuration.yml -v

#Copy the desktop icons
sudo cp /source/OSSonAzure/vm-assets/*.desktop /home/GBBOSSDemo/Desktop/
sudo chmod +x /home/GBBOSSDemo/Desktop/code.desktop
sudo chmod +x /home/GBBOSSDemo/Desktop/firefox.desktop
sudo chmod +x /home/GBBOSSDemo/Desktop/gnome-terminal.desktop
