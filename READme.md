# Deploying LAMP stack using vagrant VMs

## Setup machines in [Vagrantfile](/Vagrantfile)
![vagrant file screenshot](screenshot/Vagrantfile.jpg)

## Provision VMs

`vagrant up`
 
## Get machines IP addresses

`ip addr`

![master ip](screenshot/masterip.png)
![slave ip](screenshot/slaveip.png)

```
Master: 192.168.56.23
Slave: 192.168.56.24
```

## Run [Deployment Bashscript](screenshot/deploymaster.png)

![Install Git](screenshot/git.png)

![Install apache](screenshot/apache.png)

![Install MySQL](screenshot/MySQL.png)

![Adding ondrej/php repository](screenshot/ondrej.png)

![Install PHP](screenshot/php.png)

![Installing composer globally](screenshot/composerglobal.png)

![Clone Laravel Project](screenshot/clone.png)

![Setting up Laravel Project](screenshot/setup.png)

![Run Laravel Project](screenshot/runproject.png)

![Project Live](screenshot/projectlive.png)



## Install ansible on master, setup [hosts](/hosts) file and test connection

![hosts file](screenshot/hosts.png)

`ansible all -m ping`

![ping](screenshot/ping.png)

## Create [Ansible Playbook](./lamp.yaml)


![play](screenshot/play.jpg)


![deployed page](screenshot/deployedpage.jpg)






