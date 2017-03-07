#!/bin/bash
echo "Please customize the line below to build your customized scripts..."

echo "Change the server names"
sudo sed -i 's/[VAR1]/dansand/g' *.*
