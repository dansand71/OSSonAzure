#!/bin/bash

SOURCEDIR=$(dirname $BASH_SOURCE)
#Script Formatting
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"
YELLOW="\033[38;5;11m"
RED="\033[0;31m"
DEBUG="no"

clear
echo -e "${BOLD}Welcome to the OSS Demo Jumpbox install process.${RESET}"  
read -p "$(echo -e -n "This script will create a Jumpbox server. \e[5m [press any key to continue]:${RESET}")"
echo "Script is running from ${SOURCEDIR} Directory & will:"
echo "- Install git"
echo "- Install Azure CLI if not present"
echo "- Log in to Azure and create a Resource Group 'ossdemo-utility' and CENTOS VM"
echo "Script currently works against Ubuntu, Centos and RHEL."
echo ""
echo "Installation will require SU rights."
echo ""
echo "Starting:"$(date)
echo ".ensure we have rights on the directory to continue."
sudo chmod -R 777 ${SOURCEDIR}
if [ ${DEBUG} = "no" ]; then
    echo ".Checking OS Distro"
    if [ -f /etc/redhat-release ]; then
        echo "..found RHEL or CENTOS - proceeding with YUM."
        sudo yum update -y
        yum install epel-release
        yum install -y python-pip
        sudo yum -y install git
        sudo yum install gcc libffi-devel python-devel openssl-devel -y
        sudo yum install ansible -y
    fi
    if [ -f /etc/lsb-release ]; then
        echo "..found Ubuntu - proceeding with APT."
        gitinfo=$(dpkg-query -W -f='${Package} ${Status} \n' git | grep "git install ok installed")
        if [[ $gitinfo =~ "git install ok installed" ]]; then
            echo "...git installed - skipping"
        else  
            echo "...could not find git - installing...."
            sudo apt-get install -qq git -y
        fi
    
        echo -e "${BOLD}...Updating local binaries, software-properties-common, ansible, build-essential, libffi-dev, python...${RESET}"
        sudo apt-get install -qq software-properties-common -y
        sudo apt-add-repository ppa:ansible/ansible -y
        sudo apt-get update -qq -y
        sudo apt-get install -qq build-essential -y
        sudo apt-get install -qq libssl-dev libffi-dev python-dev -y
        sudo apt-get install -qq ansible -y
        echo "...update complete..."
    fi
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "..OSType is:" ${OSTYPE}    
        echo "    MAC Darwin - proceeding with specialized MAC install."
        sudo easy_install pip
        sudo pip install ansible
    fi

    echo ""
    echo -e "${BOLD}Installing AZ command line tools if they are missing.${RESET}"
    echo ""
    #Check to see if Azure is installed if not do it...
    if [ -f ~/bin/az ]; then
        echo ".AZ Client installed. Skipping install.."
    else
        echo ".Installing AZ Client."
        curl -L https://aka.ms/InstallAzureCli | bash
        exec -l $SHELL
    fi
    echo ".Checking for Azure CLI upgrades"
    az component update
    echo ""
    echo ".Logging in to Azure"
    #Checking to see if we are logged into Azure
    echo "..Checking if we are logged in to Azure."
    #We need to redirect the output streams to stdout
    azstatus=`~/bin/az group list 2>&1` 
    if [[ $azstatus =~ "Please run 'az login' to setup account." ]]; then
        echo "...We need to login to azure.."
        ~/bin/az login
    else
        echo "...Logged in."
    fi
    
    read -p "$(echo -e -n "${INPUT}..Change default subscription? [y/N]${RESET}")" changesubscription
    if [[ $changesubscription =~ "y" ]];then
        read -p "...New Subscription Name:" newsubscription
        ~/bin/az account set --subscription "$newsubscription"
    else
        echo "..Using default existing subscription."
    fi
fi