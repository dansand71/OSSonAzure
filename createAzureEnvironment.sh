#!/bin/bash
echo 'Use a particular subscription'
az account set --subscription "Visual Studio Enterprise"

echo 'Create docker-demo resource group'
az group create --name docker-demo --location eastus

echo 'Create docker-linux-paas-demo resource group'
az group create --name docker-linux-paas-demo --location eastus

echo 'create kubernetes-demo resource group'
az group create --name kubernetes-demo --location eastus

echo 'create utility resource group'
az group create --name utility --location eastus

