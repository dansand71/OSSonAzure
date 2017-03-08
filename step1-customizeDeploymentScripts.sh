#!/bin/bash
echo "Please customize the line below to build your customized scripts..."

echo "Change the server names"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACEME/new-short-lowercase-new-value/g'

echo "Change the REGISTRY NAME"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACE-REGISTRY-NAME/new-registry-name-from-portal/g'
