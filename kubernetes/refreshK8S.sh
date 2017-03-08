#!/bin/bash
echo "Force a refresh of the containers"
#az account set --subscription "Microsoft Azure Internal Consumption"

kubectl set image deployment/aspnet-core-linux-deployment aspnet-core-linux=REPLACE-REGISTRY-NAME-microsoft.azurecr.io/gbbossdemo/aspnet-core-linux:latest