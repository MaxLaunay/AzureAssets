# Tutorial 1 - Deploy an Azure Container Service (ACS) with Docker SWARM
## Overview


This tutorial is a part of [Azure Container Service and Docker Swam Tutorials](README.md)

It is a compilation of Microsoft documentation. I just adding some tips to help you to deploy your first Azure Container Service. In this tutorial, you will be:

1. Configure your desktop environment
2. Create an Azure Container Service using Docker Swarm
3. Create your first container

This documentation was tested with an Ubuntu 16.04

## Configure your desktop environment
To use an ACS with Docker Swarm, you need this requirements:

1. Install a default Ubuntu 16.04 : You could be find an Ubuntu distribution [here](http://www.ubuntu.com/download/desktop)
2. Install Node-JS and npm
3. Install Docker
4. Install docker-compose
5. Install Azure-cli

### Install Node-JS and npm
Documentation could be find [here](https://doc.ubuntu-fr.org/nodejs)

To install nodejs and npm, use this following command:

    sudo apt-get update && sudo apt-get install nodejs npm
    sudo apt-get install nodejs-legacy

### Install Docker
Documentation could be find [here](https://docs.docker.com/engine/installation/linux/ubuntulinux/)

Open the /etc/apt/sources.list.d/docker.list file in your favorite editor. If the file doesn’t exist, create it.

Remove any existing entries.

Add an entry for your Ubuntu operating system.

    deb https://apt.dockerproject.org/repo ubuntu-xenial main
Save and close the /etc/apt/sources.list.d/docker.list file.

install the linux-image-extra package for your kernel version

    sudo apt-get update
Install the linux-image-extra package

    sudo apt-get install linux-image-extra-$(uname -r)
Install Docker

    sudo apt-get install docker-engine

### Install Docker Compose
Documentation could be find [here](https://docs.docker.com/compose/)

First install Docker compose

    sudo apt install docker-compose

Next, get last version of docker compose (Compose repository release page on GitHub is [here](https://github.com/docker/compose/releases))

    curl -L https://github.com/docker/compose/releases/download/1.8.0-rc1/docker-compose-`uname -s`-`uname -m` > ./docker-compose
    chmod +x ./docker-compose
    sudo cp -f docker-compose /usr/bin/docker-compose
Check your version

    docker-compose --version

### Install Azure-Cli
Documentation could be find [here](https://azure.microsoft.com/fr-fr/documentation/articles/xplat-cli-install/)

    sudo npm install azure-cli -g
### Setup Azure Cli environment
First, add your azure account

    azure login -u user@domain.com
Configure the Azure CLI tools to use Azure Resource Manager

    azure config mode arm
## Create an Azure Container Service using Docker Swarm
Documentation could be find [here](https://azure.microsoft.com/en-us/documentation/articles/container-service-deployment/)

Create Azure Resource Group

    rgname='YOUR RESOURCE GROUP NAME' (eg: SWARM-RG)
    location='YOUR LOCATION' (eg: northeurope)
    azure group create $rgname $location
You need to create a SSH Key. You could use the following command to do this:

    ssh-keygen
Next, we can used an existing template provide by Microsoft (This template could be found [here](https://github.com/Azure/azure-quickstart-templates/blob/master/101-acs-swarm/docs/SwarmWalkthrough.md))

    templateURI='https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-acs-dcos/azuredeploy.json'
Get the parameters File required for the deployment

    wget https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-acs-swarm/azuredeploy.parameters.json
After, get your own public key and change the parameter sshRSAPublicKey in your parameters file with your own ssh public key.. It could be found here : `cat ~/.ssh/id_rsa.pub`

    "sshRSAPublicKey": {
      "value": "YOUR SSH PUBLIC KEY"
    }
Set a variable for Your parameters file

    parametersFile='./azuredeploy.parameters.json'
Finally, create the Swarm cluster

    azure group deployment create $rgname 'ACSDeployment' --template-uri $templateURI -e $parametersFile

## Create your first container
Documentation could be found [here](https://azure.microsoft.com/en-us/documentation/articles/container-service-connect/)

Create a DC-OS Tunnel (WARNING : id_rsa must be in /root/.ssh folder ; ssh tunnel should be initiate only by root user. Use this following command to do this: `sudo cp ~/.ssh/id_rsa* /root/.ssh/`)

    sudo ssh -L 2375:localhost:2375 -f -N username@masteragentname.location.cloudapp.azure.com -p 2200
set your DOCKER_HOST environment variable as follows

    export DOCKER_HOST=:2375
Last, you could run First container. This example (from Microsoft) creates a container from the yeasy/simple-web image:

    docker run -d -p 80:80 yeasy/simple-web
    docker run -d -p 80:80 -v /azureshare:/data yeasy/simple-web
Go to url (FQDN name of Public IP Adress of Load Balancer Agent). This url is the DNS name of the Load Balancer Agent

Now, you could create a docker compose file. Create the file `docker-compose.yml` ad insert rows below (please keep the yaml format)

    web:
    image: "yeasy/simple-web"
    ports:
    - "80:80"
    restart: "always"
Run the container with the command `docker-compose up -d`

    maxime@ubuntu:~/AzureContainerService/docker/simple-web$ docker-compose up -d
    Creating simpleweb_web_1
    maxime@ubuntu:~/AzureContainerService/docker/simple-web$ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                 NAMES
    60a656009b39        yeasy/simple-web    "/bin/sh -c 'python i"   39 seconds ago      Up 37 seconds       10.0.0.7:80->80/tcp   swarm-agent-A6A76398000003/simpleweb_web_1
Now, you could scale your application with the command `docker-compose scale web=2`

    maxime@ubuntu:~/AzureContainerService/docker/simple-web$ docker-compose scale web=2
    WARNING: The "web" service specifies a port on the host. If multiple containers for this service are created on a single host, the port will clash.
    Starting simpleweb_web_2 ... done
    maxime@ubuntu:~/AzureContainerService/docker/simple-web$
