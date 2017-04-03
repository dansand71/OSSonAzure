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

To get started with this project:
1. create a directory off of your root /source
2. clone this project from git
3. mark the script as executable
4. run the environment script

## SCRIPT to Install
```
sudo mkdir /source
cd /source
sudo git clone https://github.com/dansand71/OSSonAzure
sudo chmod +x /source/OSSonAzure/1-build-environment.sh
/source/OSSonAzure/1-build-environment.sh
```

The script installs / updates:
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



