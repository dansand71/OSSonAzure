
SOURCEDIR=$(dirname $BASH_SOURCE)

source $SOURCEDIR"/.environment_variables"

# login to azure using your credentials
az account show 1> /dev/null

if [ $? != 0 ];
then
	az login > az_subscriptions.json
else
    az account list > az_subscriptions.json
fi
## END ##


# Change Subscription?
echo -e "Current subscription is: " $(jq -r ".[] | select(.isDefault) | .name" az_subscriptions.json) ":" $(jq ".[] | select(.isDefault) | .id" az_subscriptions.json) "\n"
read -p "Change to a different subscription? (y/N)" promptChangeSubscription
promptChangeSubscription=$(echo "${promptChangeSubscription}" | tr '[:upper:]' '[:lower:]')

if [ $promptChangeSubscription != "n" ]; 
then
    subscriptionLength=$(jq 'length' az_subscriptions.json)
    
    for ((subscriptionIndex=0; subscriptionIndex<subscriptionLength; subscriptionIndex++))
    do
        echo "$(expr $subscriptionIndex + 1)."  $(jq -r ".[${subscriptionIndex}] | .name + \" (\" + .id + \")\"" az_subscriptions.json)
    done

    read -p "Choose subscription (1 - $subscriptionLength): " subscriptionChoice
    subscriptionChoice=$(expr $subscriptionChoice - 1)
    az account set --subscription $(jq -r ".[$subscriptionChoice] | .id")

    echo -e "Subscription changed to: $(az account list | jq -r ".[] | select(.isDefault) | .name + \" (\" + .id + \")\" " )"
fi
## END ##


# Use default Resource Group?
az_rg_exists=$(az group show --name ${AZ_RESOURCE_GROUP_NAME} | jq '.name')

if [ -z "$az_rg_exists" ];
then 
    read -p "Resource Group '$AZ_RESOURCE_GROUP_NAME' does not exist.  Create and use group '$AZ_RESOURCE_GROUP_NAME'? (Y/n):" useOrCreateResourceGroup    
else 
    read -p "Use Resource Group ${AZ_RESOURCE_GROUP_NAME}? (Y/n): " useOrCreateResourceGroup
fi

useOrCreateResourceGroup=$(echo "${useOrCreateResourceGroup}" | tr '[:upper:]' '[:lower:]')

if [[ $useOrCreateResourceGroup = 'y' &&  -z "$az_rg_exists" ]];
then
    read -p "Please enter the Azure Region to deploy Resource Group to (default '$AZ_LOCATION)'):" AZ_LOCATION
    # create Azure Resource Group

    echo -e "Creating Resouce Group...\n"
    az group create \
        --name ${AZ_RESOURCE_GROUP_NAME} \
        --location ${AZ_LOCATION}
        
    echo -e "Resource Group ${AZ_RESOURCE_GROUP_NAME} created in ${AZ_LOCATION}.\n\n"
fi

if [[ $useOrCreateResourceGroup = 'n' ]];
then
    echo -e "Select another Resource Group to use:"

    az group list > az_resourceGroups.json
    resourceGroupLength=$(jq 'length' az_resourceGroups.json)
    
    for ((resourceGroupIndex=0; resourceGroupIndex<resourceGroupLength; resourceGroupIndex++))
    do
        echo "$(expr $resourceGroupIndex + 1)."  $(jq -r ".[${resourceGroupIndex}] | .name" az_resourceGroups.json)
    done

    read -p "Choose Resource Group (1 - $resourceGroupLength): " resourceGroupChoice
    resourceGroupChoice=$(expr $resourceGroupChoice - 1)
    AZ_RESOURCE_GROUP_NAME=$(jq -r ".[$resourceGroupChoice] | .name" az_resourceGroups.json)
fi

echo -e "Now using Resource Group: $AZ_RESOURCE_GROUP_NAME"
## END ##

## Deploy Template

### Gather user input (work around for az command issues with user inputed parameters)
# generate Azure Template Parameters File from example
cp ${ARM_TEMPLATE_FOLDER}/jumpbox.parameters.json.example ${ARM_PARAMETERS_FILE}
echo -e "Generated Parameters File for Jumpbox ARM Template\n\n"
echo -e "Updating Parameters...\n"
## END ##

### jumpboxServerName
read -p "Jumpbox Server Name: " JUMPBOX_SERVER_NAME
jq ".parameters.jumpboxServerName.value = \"$JUMPBOX_SERVER_NAME\" " $ARM_PARAMETERS_FILE > $ARM_PARAMETERS_FILE.temp
mv $ARM_PARAMETERS_FILE.temp $ARM_PARAMETERS_FILE

### jumpboxAdminName
read -p "Jumpbox Server Admin Name: " JUMPBOX_ADMIN_NAME
jq ".parameters.jumpboxAdminName.value = \"$JUMPBOX_ADMIN_NAME\" " $ARM_PARAMETERS_FILE > $ARM_PARAMETERS_FILE.temp
mv $ARM_PARAMETERS_FILE.temp $ARM_PARAMETERS_FILE

### jumpboxPassword
read -s -p "Jumpbox Server Admin Password: " JUMPBOX_ADMIN_PASSWORD
echo -e "\n"
jq ".parameters.jumpboxAdminPassword.value = \"$JUMPBOX_ADMIN_PASSWORD\" " $ARM_PARAMETERS_FILE > $ARM_PARAMETERS_FILE.temp
mv $ARM_PARAMETERS_FILE.temp $ARM_PARAMETERS_FILE

### ssh-key
### Auto Generate ssh-keys?
read -p "Auto generate new ssh-keys? (Y/n):" autoGenerateSSHKeys
autoGenerateSSHKeys=$(echo "${autoGenerateSSHKeys}" | tr '[:upper:]' '[:lower:]')

# ## TODO prompt and generate keys
# ssh_pub_key_location=~/.ssh/id_rsa.pub

# jq ".parameters.sshkey.value = \"$(cat ${ssh_pub_key_location})\" " $ARM_PARAMETERS_FILE > $ARM_PARAMETERS_FILE.temp
# mv $ARM_PARAMETERS_FILE.temp $ARM_PARAMETERS_FILE

# # deploy Azure Template
# echo -e "Deploying ARM Template...\n"
# az group deployment create \
#     --name test-ossdemo \
#     --resource-group ${AZ_RESOURCE_GROUP} \
#     --template-file ${ARM_TEMPLATE_FILE}
#     --parameters-file ${ARM_PARAMETERS_FILE}

# if [ $? = 0 ];
# then
# 	echo -e "Jumpbox deployed."
# fi
## END ##

# echo -e "Deployment output can be found in '${JUMPBOX_OUTPUT_FILE}'\n\n"



# output new server FQDN
# JUMPBOX_FQDN=$(cat jumpbox.deployment.output.json | jq -r '.properties.outputs.dnsName.value')
# echo -e "Server can be reached at: $JUMPBOX_FQDN\n"
# echo -e "ssh $JUMPBOX_ADMIN_NAME@$JUMPBOX_FQDN\n\n"

