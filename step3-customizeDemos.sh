#!/bin/bash
echo "Please customize the line below to build your customized demo environment..."
echo "This should be run on the LINUX Utility server after the initial environment setup."

echo "Change the server names"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACEME/new-short-lowercase-new-value/g'

echo "Change the REGISTRY NAME"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACE-REGISTRY-NAME/new-registry-name-from-portal/g'

echo "Change the REGISTRY PASSWORD"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACE-REGISTRY-PASSWORD/new-password-from-portal/g'

echo "Change the APP INSIGHT KEY "
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACE-APP-INSIGHTS-KEY/new-app-insights-key-from-portal/g'

echo "Change the OMS Workspace"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACE-OMS-WORKSPACE/new-oms-workspacekey-from-portal/g'

echo "Change the OMS Subscription ID"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACE-OMS-SUBSCRIPTIONID/new-oms-subscriptionkey-from-portal/g'