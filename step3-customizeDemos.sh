#!/bin/bash
echo "Please customize the line below to build your customized demo environment..."
echo "This should be run on the LINUX Utility server after the initial environment setup."

echo "Change the server names"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACEME/dansand/g'

echo "Change the REGISTRYPASSWORD Password"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACEME/dansand/g'

echo "Change the APPINSIGHTKEY names"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACEME/dansand/g'