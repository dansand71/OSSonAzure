#!/bin/bash
echo 'Use a particular subscription - you should modify this for your scenrio'
#az account set --subscription "Microsoft Azure Internal Consumption"

echo 'Delete docker-demo resource group'
az group delete --name ossdemo-docker -y --no-wait

echo 'Delete docker-linux-paas-demo resource group'
az group delete --name ossdemo-docker-linux-paas -y --no-wait

echo 'Delete kubernetes-demo resource group'
az group delete --name ossdemo-kubernetes -y --no-wait

echo 'Delete utility resource group'
az group delete --name ossdemo-utility -y --no-wait

