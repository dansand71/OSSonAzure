
SOURCEDIR=$(dirname $BASH_SOURCE)

source $SOURCEDIR"/.environment_variables"

# login to azure using your credentials
az account show 1> /dev/null

if [ $? != 0 ];
then
	az login > accounts.json
fi

# create Azure Resource Group
echo -e "Creating Resouce Group...\n"
az group create \
    --name ${AZ_RESOURCE_GROUP} \
    --location ${AZ_LOCATION}

echo -e "Done.\n\n"



# generate Azure Template Parameters
cp ${ARM_TEMPLATE_FOLDER}/jumpbox.parameters.json.example ${ARM_PARAMETERS_FILE}
echo -e "Generated Parameters File for Jumpbox ARM Template\n\n"
echo -e "Updating Parameters...\n"



# deploy Azure Template
echo -e "Deploying ARM Template...\n"
az group deployment create \
    --name test-ossdemo \
    --resource-group ${AZ_RESOURCE_GROUP} \
    --template-file ${ARM_TEMPLATE_FILE}

if [ $? = 0 ];
then
	echo -e "Jumpbox deployed."
fi

# echo -e "Deployment output can be found in '${JUMPBOX_OUTPUT_FILE}'\n\n"



# output new server FQDN
# JUMPBOX_FQDN=$(cat jumpbox.deployment.output.json | jq -r '.properties.outputs.dnsName.value')
# echo -e "Server can be reached at: $JUMPBOX_FQDN\n"
# echo -e "ssh $JUMPBOX_ADMIN_NAME@$JUMPBOX_FQDN\n\n"

