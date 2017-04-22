
SOURCEDIR=$(dirname $BASH_SOURCE)
#Script Formatting
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
DEBUG="no"

# Jumpbox server variables defaults
JUMPBOX_SERVER_PREFIX="ossdemo"
JUMPBOX_ADMIN_NAME="kenobi"
JUMPBOX_ADMIN_PASSWORD="H3ll0Ben!"
JUMPBOX_OUTPUT_FILE="jumpbox.deployment.output.json"

# Azure deployment variables defaults
AZ_RESOURCE_GROUP="ossdemo"
AZ_LOCATION="eastus"

# ARM template defaults
ARM_TEMPLATE_FOLDER="arm_templates"
ARM_TEMPLATE_FILENAME="jumpbox.arm.json"
ARM_PARAMETERS_FILENAME="jumpbox.parameters.json"
ARM_TEMPLATE_FILE_LOCATION=$ARM_TEMPLATE_FOLDER"/"$ARM_TEMPLATE_FILENAME
ARM_PARAMETERS_FILE=$ARM_TEMPLATE_FOLDER"/"$ARM_PARAMETERS_FILENAME

# create Azure Resource Group
printf "Creating Resouce Group...\n"
az group create --name ${AZ_RESOURCE_GROUP} --locaiton ${AZ_LOCATION}
printf "Done.\n\n"

# generate Azure Template Parameters
cp ${ARM_TEMPLATE_FOLDER}jumbox.parameters.json.example ${ARM_PARAMETERS_FILE}
printf "Generated Parameters File for Jumpbox ARM Template\n\n"
printf "Updating Parameters...\n"
# todo: replace default values with user inputed values

# deploy Azure Template
printf "Deploying ARM Template...\n"
az group deployment create --name test-ossdemo --resource-group ${AZ_RESOURCE_GROUP} --template-file ${ARM_TEMPLATE_FILE} > $JUMPBOX_OUTPUT_FILE
printf "Done."
printf "Deployment output can be found in '${JUMPBOX_OUTPUT_FILE}'\n\n"

cat jumpbox.deployment.output.json | jq -r '.properties.outputs.dnsName.value'
