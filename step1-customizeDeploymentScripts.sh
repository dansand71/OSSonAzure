#!/bin/bash
echo "Please customize the line below to build your customized scripts..."

echo "Change the server names"
sudo find . -type f -exec sed -i 's/REPLACEME/dansand/g' {} +
