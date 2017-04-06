SOURCEDIR=$(dirname $BASH_SOURCE)
echo "---------------------------------------------"
echo "Configure demo template values file"
cp ${SOURCEDIR}/vm-assets/DemoEnvironmentValues-template ${SOURCEDIR}/vm-assets/DemoEnvironmentValues -f
sudo sed -i -e "s@JUMPBOX-SERVER-NAME=@JUMPBOX-SERVER-NAME=jumpbox-dansand.eastus.cloudapp.azure.com@g" ${SOURCEDIR}/vm-assets/DemoEnvironmentValues
sudo sed -i -e "s@DEMO-STORAGE-ACCOUNT=@DEMO-STORAGE-ACCOUNT=dansandstorage@g" ${SOURCEDIR}/vm-assets/DemoEnvironmentValues




#mkdir for source on jumpbox server
echo "Copying the template values file to the jumpbox server in /source directory."
echo "Starting:"$(date)
scp ${SOURCEDIR}/vm-assets/DemoEnvironmentValues gbbossdemo@jumpbox-${serverPrefix}.eastus.cloudapp.azure.com:/source/DemoEnvironmentValues

echo ""
echo "Launch Microsoft or MAC RDP via --> mstsc and enter your jumpbox servername:jumpbox-${serverPrefix}.eastus.cloudapp.azure.com" 
sudo cp ${SOURCEDIR}/vm-assets/JUMPBOX-SERVER.rdp ${SOURCEDIR}/OSSDemo-jumpbox-server.rdp
sudo sed -i -e "s@JUMPBOX-SERVER-NAME@jumpbox-${serverPrefix}@g" ${SOURCEDIR}/OSSDemo-jumpbox-server.rdp




