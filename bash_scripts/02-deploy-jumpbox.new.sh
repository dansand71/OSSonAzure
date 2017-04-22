
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

# Azure deployment variables defaults
AZ_RESOURCE_GROUP="ossdemo"
AZ_LOCATION="eastus"

# create Azure Resource Group
az group create --name ${AZ_RESOURCE_GROUP} --locaiton ${AZ_LOCATION}
az group deployment create --name test-ossdemo --resource-group ${AZ_RESOURCE_GROUP} --template-file arm_templates/jumpbox.arm.json >> jumpbox.deployment.output.json