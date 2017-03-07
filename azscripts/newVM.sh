az login
echo "Create VM #1"
az vm create -g 'ossdemo-docker' -n ossdemo-rhel21 --public-ip-address-dns-name 'ossdemo-rhel21' --os-disk-name 'rhel21-disk' \
        --image "RedHat:RHEL:7.2:latest" --os-type linux  --nsg 'NSG-ossdemo-docker'  --storage-sku 'Premium_LRS' \
        --size Standard_DS2_v2  --availability-set 'ossdemo-docker-availabilityset'  --admin-username GBBOSSDemo  \
        --no-wait \
        --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222' 

echo "Create VM #2"
az vm create -g 'ossdemo-docker' -n ossdemo-rhel22 --public-ip-address-dns-name 'ossdemo-rhel22' --os-disk-name 'rhel22-disk' \
        --image "RedHat:RHEL:7.2:latest" --os-type linux  --nsg 'NSG-ossdemo-docker'  --storage-sku 'Premium_LRS' \
        --size Standard_DS2_v2  --availability-set 'ossdemo-docker-availabilityset'  --admin-username GBBOSSDemo  \
        --no-wait \
        --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222'
