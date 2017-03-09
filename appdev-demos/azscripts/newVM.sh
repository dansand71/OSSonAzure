echo "Be sure to login to Azure prior to running this script."
#az account set --subscription "Microsoft Azure Internal Consumption"
echo "Create VM #1"
az vm create -g 'ossdemo-docker' -n ossdemo-svr21-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'ossdemo-svr21-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr21-disk' --image "OpenLogic:CentOS:7.2:latest" --os-type linux --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2  --admin-username GBBOSSDemo \
        --nsg 'NSG-ossdemo-docker' \
        #--availability-set 'ossdemo-docker-availabilityset' \
        --no-wait \
        --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222' 

echo "Create VM #2"
az vm create -g 'ossdemo-docker' -n ossdemo-svr22-VALUEOF-UNIQUE-SERVER-PREFIX \
        --public-ip-address-dns-name 'ossdemo-svr22-VALUEOF-UNIQUE-SERVER-PREFIX' \
        --os-disk-name 'svr22-disk' --image "OpenLogic:CentOS:7.2:latest" --os-type linux --storage-sku 'Premium_LRS' \
        --size Standard_DS1_v2 --admin-username GBBOSSDemo  \
        --nsg 'NSG-ossdemo-docker' \
        #--availability-set 'ossdemo-docker-availabilityset' \
        --no-wait \
        --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222'

#echo "Create VM #RHEL"
#az vm create -g 'ossdemo-docker' -n ossdemo-svr23-VALUEOF-UNIQUE-SERVER-PREFIX \
#        --public-ip-address-dns-name 'ossdemo-svr23-VALUEOF-UNIQUE-SERVER-PREFIX' \
#        --os-disk-name 'svr23-disk' --image "RedHat:RHEL:7.2:latest" --os-type linux --storage-sku 'Premium_LRS' \
#        --size Standard_DS1_v2 --admin-username GBBOSSDemo  \
#        --nsg 'NSG-ossdemo-docker' --availability-set 'ossdemo-docker-availabilityset' \
#        --no-wait \
#        --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222'
        
