#!/bin/bash
echo "Please customize the line below to build your customized demo environment..."
echo "This should be run on the LINUX Utility server after the initial environment setup."

echo "Change the server names"
sudo sed -i 's/[VAR1]/[lowercasename]/g' *.*

echo "Change the Azure Insights Passworkd"
sudo sed -i 's/[REPLACE-REGISTRY-PASSWORD]/[NEW REGISTRY PASSWORD FROM PORTAL]/g' *.*

echo "Change the server names"
sudo sed -i 's/[REPLACE-APP-INSIGHTS-KEY]/[NEW APP INSIGHTS KEY FROM PORTAL]/g' *.*