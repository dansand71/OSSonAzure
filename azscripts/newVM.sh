az login
echo "Create VM"
az vm create -g 'docker-demo' /
    -n rhel15 --public-ip-address-dns-name 'dansand-rhel21' --os-disk-name 'rhel21-demo-disk' /
    --image "RedHat:RHEL:7.2:latest" --os-type linux /
    --nsg 'NSG-dockerdemo'  --storage-sku 'Premium_LRS' --size Standard_DS2_v2  /
    --availability-set 'docker-demo-availabilityset' /
    --admin-username GBBOSSDemo /
    --ssh-key-value 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAz7ItfqCoqLGGbSdNT52SrZvIO2Fc26yUUyPxohN4IYxUcc1O9tmXzxHwah0jwMOw6ux+JbycOEiEpxoYPLOe9R98cKMyilnL9hGs6jCmVmRLuc/ny76euR2t8v0lhGT1yTrkLpwIlfkcaDqpufkIqQmqd20NlWbdHzsYA+s++e3jIgE5qJwO/InlMvv90nkPftR/PRYq7etWgImi00qQgX1VcD8NMZzm1qC4unzEQhYbIqYAgScCzeaj5U5NSOvDm6wgwceBCcdM8jSm7SYdetVm3J3cd+hO+SVKYgx8Zg1+kdh9RkaE2+ZRr0wtoUi/ClOXb53a4rtfYYzj85/W9w== rsa-key-20170222' 

