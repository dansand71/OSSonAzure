# OSSonAzure
OSS on Azure Demos framework

This project builds the framwork needed for additional demos including:
- Linux Containers on Azure with Docker, K8S and Azure Linux PaaS and .NET Core
- Azure Management integration with Application Insights and OMS for containers and Linux infrastructure
- Image creation and migration to Azure for RHEL, Centos and Ubuntu VM's
- and many more to come....

This particular project is comprised of a single shell script that has been tested to run on the following environments:
- Ubuntu Shell on Windows.  For installation instructions and please see - https://msdn.microsoft.com/en-us/commandline/wsl/install_guide 
- MacOS Sierra
- Centos 7.3
- RHEL 7

There are multiple ways to create the initial JUMPBOX on Azure:
1. Azure CloudShell
2. Local Docker Image
3. Native install of tools and Azure CLI on your client

## SCRIPT to Install via CloudShell
1. Open the Cloud Shell from the Azure portal
2. Paste the command below

```
git clone https://github.com/dansand71/OSSonAzure
chmod +x ./OSSonAzure/fromportal-build-environment.sh
./OSSonAzure/fromportal-build-environment.sh
```

## SCRIPT to Install via Local Docker
1. Configure Hyper-V or Virtual Box as needed if you are on Windows 
2. Install "Docker for Mac" or "Docker for Windows"
3. Configure Disk Sharing so that the SSH keys can be persisted after container deletion
4. If on Windows create a directory for your SSH Keys
3. Paste the command below

```
#MAC_Example
docker run -it -v /<local directory for SSH files>:/root/.ssh dansand71/ossonazure bash './OSSonAzure/fromdocker-build-environment.sh'

#WINDOWS_Example
docker run -it -v c:/<local directory for SSH files>:/root/.ssh dansand71/ossonazure bash './OSSonAzure/fromdocker-build-environment.sh'
```

## SCRIPT to Install via your LOCAL machine
```
git clone https://github.com/dansand71/OSSonAzure
sudo chmod +x ./OSSonAzure/1-build-environment.sh
./OSSonAzure/1-build-environment.sh
```

The local script installs / updates:
- Updates YUM / APT-GET
- Installs git
- Installs Ansible
    - On Mac installs via easy_install pip
- Installs pre-reqs for Azure CLI - livffi-dev, python-dev

Configures Azure:
- Prompts for user provided server postfix which will become jumbox-{postfix}
- Creates Resource group for jumpbox server - ossdemo-utility
- Crates Network Security Group (NSG) and allows 22 and 3389 inbound - these can be limited to specific IP ranges as needed
- Creates new SSH keys in ~/.ssh directory for jumpbox server & copies these up to the server for later demo's

Once Jumpbox server (CENTOS 7.3) is created the ansible yml file:
- updates YUM
- installs ansible, git
- installs epel, python, pip
- installs docker, docker-py & sets docker to start
- installs xrdp for demo purposes and allows RDP access in to GNOME shell
- installs .NET core, Visual Studio Code
- installs pre-reqs for Azure CLI - libffi-devel, python-devel, openssl-devel
- installs autoconf, automake, developer tools
- installs GNOME - for demo purposes to show cross platform debugging