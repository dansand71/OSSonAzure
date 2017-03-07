#!/bin/bash
echo 'Use a particular subscription'
az account set --subscription "Visual Studio Enterprise"

echo 'Delete docker-demo resource group'
az group delete --name docker-demo

echo 'Delete docker-linux-paas-demo resource group'
az group delete --name docker-linux-paas-demo 

echo 'Delete kubernetes-demo resource group'
az group delete --name kubernetes-demo 

echo 'Delete utility resource group'
az group delete --name utility

