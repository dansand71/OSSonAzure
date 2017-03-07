#!/bin/bash
echo "Please customize the line below to build your customized scripts..."

echo "Change the server names"
sudo grep -rl REPLACEME ./ | sudo xargs sed -i 's/REPLACEME/dansand/g'
