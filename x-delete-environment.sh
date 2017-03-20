echo ""
read -p "This will distroy the ossdemo-utility resource group.  This process is not reversable.  Continue? [y/n]:"  continuescript
if [[ $continuescript == "y" ]];then
    ~/bin/az group delete --name ossdemo-utility -y
fi