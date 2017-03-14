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
vagrant up provider=aws
```

### Hyku AWS (Centos7)

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
```

Run:

```
cd aws_hyku
vagrant up provider=aws
```

#### Post-Install Steps

edit the following to provide the solr and fedora uri and paths:

* config/fedora.yml
* config/solr.yml
* config/blacklight.yml

add the solr uri and set admin_host to the ip address of the server in here:

* config/settings.yml

This will run Hyku in single-tenancy mode.

### Fedora local or AWS (Ubuntu)

Lightly modified Vagrantfile from https://github.com/VTUL/fcrepo4-ansible

* Checkout https://github.com/VTUL/fcrepo4-ansible
* Replace the Vagrant file with this one
* Create an .env file as per Hyku AWS

## Other Scripts

### provision_hyrax_ubuntu.sh 

incomplete script to run ulcc_hyrax on ubuntu 16.04

