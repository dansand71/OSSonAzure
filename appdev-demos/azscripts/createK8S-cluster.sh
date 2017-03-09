echo "Be sure to login to Azure prior to running this script."
#az account set --subscription "Microsoft Azure Internal Consumption"

##TO-DO - TURN on Diagnostics as well as POWER-OFF TIMES
#az vm boot-diagnostics enable -n centos-utility -g utility

#CREATE KUBERNETES CLUSTER
echo ""
echo 'Create Kubernetes cluster for K8S Demo'
echo "--------------------------------------------"

echo "CREATE K8S Cluster"
az acs create --orchestrator-type=kubernetes --resource-group=ossdemo-kubernetes \
        --name=ossdemo-k8s-VALUEOF-UNIQUE-SERVER-PREFIX --dns-prefix=ossdemo-k8s-VALUEOF-UNIQUE-SERVER-PREFIX \
        --agent-vm-size Standard_DS1_v2
        --admin-username GBBOSSDemo --master-count 1 \
        --ssh-key-value='ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222'

echo "Attempting to install the kubernetes client within the Azure CLI tools.  This can fail.  Try to resolve and re-run: sudo az acs kubernetes install-cli"
az acs kubernetes install-cli --install-location ~/bin/kubectl