
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
ARM_TEMPLATE_FOLDER="arm_templates/"
ARM_TEMPLATE_FILE=$ARM_TEMPLATE_FOLDER"jumpbox.arm.json"
ARM_PARAMETERS_FILE=$ARM_TEMPLATE_FOLDER"jumpbox.parameters.json"

# create Azure Resource Group
printf "Creating Resouce Group...\n"
az group create --name ${AZ_RESOURCE_GROUP} --locaiton ${AZ_LOCATION}
printf "Done.\n\n"

printf "Deploying ARM Template...\n"
az group deployment create --name test-ossdemo --resource-group ${AZ_RESOURCE_GROUP} --template-file ${ARM_TEMPLATE_FILE} > $JUMPBOX_OUTPUT_FILE
printf "Done."
printf "Deployment output can be found in '${JUMPBOX_OUTPUT_FILE}'\n\n"