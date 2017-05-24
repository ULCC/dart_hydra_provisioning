# dart_hydra_provisioning
Hydra Provisioning Scripts

These scripts are for **_development_** instances only.

## Vagrant

### Hydra

To deploy a Centos7 Virtual Box with Hyku and ULCC_Hyrax, using Vagrant:

```
cd hydra
vagrant up
```

The following scripts can be run standalone from any CentosBox to deploy either Hyku or ULCC_Hyrax:

```
hydra\provision_hyku.sh
hydra\provision_hyrax.sh
```

### Solr AWS (Centos7)

Make sure vagrant-env is installed

```
vagrant plugin install vagrant-env
```

Create a file called .env within the aws_solr directory containing the following:

```
KEYPAIR_NAME=
KEYPAIR_FILE=
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
AWS_SECURITY_GROUPS= # space-separated
AWS_SUBNET=
```

Run:

```
cd aws_solr
vagrant up --provider=aws
```

### Hyku AWS (Centos7)

Edit the following to provide the solr and fedora uri and paths:

* install_files/fedora.yml
* install_files/solr.yml
* install_files/blacklight.yml

add the solr uri and set admin_host to the ip address of the server in here 
(see note below is only available after 'vagrant up'):

* install_files/settings.yml

Hyku will run in single-tenancy mode.

Make sure vagrant-env is installed

```
vagrant plugin install vagrant-env
```

Create a file called .env within the aws_hyku directory containing the following:

```
KEYPAIR_NAME=
KEYPAIR_FILE=
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
AWS_SECURITY_GROUPS= # space-separated
AWS_SUBNET=
```

Run:

Because we need to add the server ip as admin_host in settings.yml
 
 ```
 vagrant up --no-provision
 # add the server ip into install_files/settings.yml
 # add the server ip (port 3000) into an AWS security group that the solr/fedora servers have available
 # this is so that this server can access solr and fedora
 vagrant provision
```

If this wasn't needed, the command would be:

```
cd aws_hyku
vagrant up --provider=aws
```

Variables at the top of provision_hyku.sh can be changed:

```
FITS="1.0.2"
RUBY="2.3.3"
RAILS="5.0.2"
RAILS_MODE="production"
BRANCH="master"
```

***Issue***:
On running vagrant provision, the terminal never outputs, displaying 'Sending SSH keep-alive' indefinitely.
Quitting with CTRL+C doesn't affect the server so is fine, but this isn't the correct behaviour and needs looking into.

### Fedora local or AWS (Ubuntu)

Lightly modified Vagrantfile from https://github.com/VTUL/fcrepo4-ansible

* Checkout https://github.com/VTUL/fcrepo4-ansible
* Replace the Vagrant file with this one
* Create an .env file as per Hyku AWS

## Other Scripts

### provision_hyrax_ubuntu.sh 

incomplete script to run ulcc_hyrax on ubuntu 16.04

