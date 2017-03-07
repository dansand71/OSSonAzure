#!/bin/bash
echo 'Use a particular subscription'
az account set --subscription "Visual Studio Enterprise"

echo 'Delete docker-demo resource group'
az group delete --name ossdemo-docker

echo 'Delete docker-linux-paas-demo resource group'
az group delete --name ossdemo-docker-linux-paas 

echo 'Delete kubernetes-demo resource group'
az group delete --name ossdemo-kubernetes

echo 'Delete utility resource group'
az group delete --name ossdemo-utility

