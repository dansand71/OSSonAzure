#Set Scripts as executable
sudo chmod +x /source/OSSonAzure/appdev-demos/kubernetes/configK8S.sh
sudo chmod +x /source/OSSonAzure/appdev-demos/kubernetes/refreshK8S.sh
sudo chmod +x /source/OSSonAzure/appdev-demos/kubernetes/deploy.sh

sudo chmod +x /source/OSSonAzure/appdev-demos/azscripts/newVM.sh
sudo chmod +x /source/OSSonAzure/appdev-demos/azscripts/createAzureRegistry.sh
sudo chmod +x /source/OSSonAzure/appdev-demos/azscripts/createK8S-cluster.sh

##Please ensure your logged in to azure via the CLI & your subscription is set correctly

#Create new worker VM's for the docker demo
/source/OSSonAzure/appdev-demos/azscripts/newVM.sh

#Create Azure Registry
/source/OSSonAzure/appdev-demos/azscripts/createAzureRegistry.sh

#Create K8S Cluster
/source/OSSonAzure/appdev-demos/azscripts/createK8S-cluster.sh