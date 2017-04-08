SOURCEDIR=$(dirname $BASH_SOURCE)
#Script Formatting
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
DEBUG="no"

echo "Resetting KNOWN HOSTS due to issues with re-using jumpbox names"
echo "" ~/.ssh/known_hosts

clear
echo ""
echo -e "${BOLD}Set values for creation of resource groups and jumpbox server${RESET}"
# Check the validity of the name (no dashes, spaces, less than 8 char, no special chars etc..)
# Can we set a Enviro variable so if you want to rerun it is here and set by default?
echo ".Please enter your unique server prefix: (Jumpbox server will become:'jumpbox-PREFIX')"
echo "     (Note - values should be lowercase and less than 8 characters.)"
read -p "$(echo -e -n "${INPUT}.Server Prefix:${RESET}")" serverPrefix
# This requires a newer version of BASH not avialble in MAC OS - serverPrefix=${serverPrefix,,} 
serverPrefix=$(echo "${serverPrefix}" | tr '[:upper:]' '[:lower:]')

echo ".Please enter your new admin username:"
echo "     (Note - values should be lowercase and less than 8 characters.)" 
read -p "$(echo -e -n "${INPUT}.Admin Name:${RESET}")" serverAdminName
# This requires a newer version of BASH not avialble in MAC OS - serverPrefix=${serverPrefix,,} 
serverAdminName=$(echo "${serverAdminName}" | tr '[:upper:]' '[:lower:]')

# Check the validity of the name (no dashes, spaces, less than 8 char, no special chars etc..)"
# Can we set a Enviro variable so if you want to rerun it is here and set by default?
echo ".Please enter your unique storage prefix: (Storage Account will become: 'PREFIX-storage'')"
echo "      (Note - values should be lowercase and less than 8 characters.)"
read -p "$(echo -e -n "${INPUT}.Storage Prefix? (default: ${serverPrefix}demostorage):"${RESET})" storagePrefix
[ -z "${storagePrefix}" ] && storagePrefix=${serverPrefix}
# This requires a newer version of BASH not avialble in MAC OS - storagePrefix=${storagePrefix,,} 
storagePrefix=$(echo "${storagePrefix}" | tr '[:upper:]' '[:lower:]')


### JUMPBOX SERVER PASSWORD
while true
do
  read -p "$(echo -e -n "${INPUT}.New Admin Password for Jumpbox:${RESET}")" jumpboxPassword
  read -p "$(echo -e -n "${INPUT}.Re-enter to verify:${RESET}")" jumpboxPassword2
  
  if [ $jumpboxPassword = $jumpboxPassword2 ]
  then
     break 2
  else
     echo -e ".${RED}Passwords do not match.  Please retry. ${RESET}"
  fi
done

    #stty -echo
    #    read -s jumpboxPassword
    #stty echo


#Download the GIT Repo for keys etc.
echo "--------------------------------------------"
echo -e "${BOLD}Configuring jumpbox server with ansible${RESET}"
echo ".Starting:"$(date)
cp ${SOURCEDIR}/ansible/jumpbox-server-configuration-template.yml ${SOURCEDIR}/ansible/jumpbox-server-configuration.yml -f
cp ${SOURCEDIR}/ansible/hosts-template ${SOURCEDIR}/ansible/hosts -f
sudo sed -i -e "s@JUMPBOXSERVER-REPLACE.eastus.cloudapp.azure.com@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com@g" ${SOURCEDIR}/ansible/hosts
sudo sed -i -e "s@VALUEOF_DEMO_ADMIN_USER@${serverAdminName}@g" ${SOURCEDIR}/ansible/jumpbox-server-configuration.yml

echo ""
echo "---------------------------------------------"
echo "Configure demo template values file"
echo ".current pwd:" $(pwd) " current location of script:"${SOURCEDIR}
cp ${SOURCEDIR}/vm-assets/DemoEnvironmentValues-template ${SOURCEDIR}/vm-assets/DemoEnvironmentValues -f
sudo sed -i -e "s@JUMPBOX_SERVER_NAME=@JUMPBOX_SERVER_NAME=jumpbox-${serverPrefix}.eastus.cloudapp.azure.com@g" ${SOURCEDIR}/vm-assets/DemoEnvironmentValues
sudo sed -i -e "s@DEMO_SERVER_PREFIX=@DEMO_SERVER_PREFIX=${serverPrefix}@g" ${SOURCEDIR}/vm-assets/DemoEnvironmentValues
sudo sed -i -e "s@DEMO_STORAGE_ACCOUNT=@DEMO_STORAGE_ACCOUNT=${storagePrefix}storage@g" ${SOURCEDIR}/vm-assets/DemoEnvironmentValues
sudo sed -i -e "s@DEMO_STORAGE_PREFIX=@DEMO_STORAGE_PREFIX=${storagePrefix}@g" ${SOURCEDIR}/vm-assets/DemoEnvironmentValues
sudo sed -i -e "s@DEMO_ADMIN_USER=@DEMO_ADMIN_USER=${serverAdminName}@g" ${SOURCEDIR}/vm-assets/DemoEnvironmentValues

#Set the remote jumpbox passwords
echo "Resetting ${serverAdminName} and root passwords based on script values."
echo "Starting:"$(date)
ssh ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com -i ~/.ssh/jumpbox_${serverPrefix}_id_rsa "echo "${serverAdminName}:${jumpboxPassword}" | sudo chpasswd"
ssh ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com -i ~/.ssh/jumpbox_${serverPrefix}_id_rsa "echo "root:${jumpboxPassword}" | sudo chpasswd"

#Copy the SSH private & public keys up to the jumpbox server
echo "Copying up the SSH Keys for demo purposes to the jumpbox ~/.ssh directories for ${serverAdminName} user."
echo "Starting:"$(date)
scp ~/.ssh/jumpbox_${serverPrefix}_id_rsa ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com:~/.ssh/id_rsa
scp ~/.ssh/jumpbox_${serverPrefix}_id_rsa.pub ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com:~/.ssh/id_rsa.pub
ssh ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com -i ~/.ssh/jumpbox_${serverPrefix}_id_rsa 'sudo chmod 600 ~/.ssh/id_rsa'

#mkdir for source on jumpbox server
echo "Copying the template values file to the jumpbox server in /source directory."
echo "Starting:"$(date)

ssh ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com -i ~/.ssh/jumpbox_${serverPrefix}_id_rsa 'sudo mkdir /source'
ssh ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com -i ~/.ssh/jumpbox_${serverPrefix}_id_rsa 'sudo chmod 777 -R /source'
scp ${SOURCEDIR}/vm-assets/DemoEnvironmentValues ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com:/source/DemoEnvironmentValues

echo ""
echo "Launch Microsoft or MAC RDP via --> mstsc and enter your jumpbox servername:jumpbox-${serverPrefix}.eastus.cloudapp.azure.com" 
echo "   or leverage the RDP file created in /source/JUMPBOX-SERVER.rdp"
sudo cp ${SOURCEDIR}/vm-assets/JUMPBOX-SERVER.rdp ${SOURCEDIR}/OSSDemo-jumpbox-server.rdp
sudo sed -i -e "s@VALUEOF_JUMPBOX_SERVER_NAME@jumpbox-${serverPrefix}@g" ${SOURCEDIR}/OSSDemo-jumpbox-server.rdp
sudo sed -i -e "s@VALUEOF_DEMO_ADMIN_USER@${serverAdminName}@g" ${SOURCEDIR}/OSSDemo-jumpbox-server.rdp


echo "SSH is available via: ssh ${serverAdminName}@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com -i ~/.ssh/jumpbox_${serverPrefix}_id_rsa "
echo ""
echo "Enjoy and please report any issues in the GitHub issues page or email GBBOSS@Microsoft.com..."
echo ""
echo "Finished:"$(date)