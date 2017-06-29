# dart_hydra_provisioning
Hydra Provisioning Scripts for deploying Hyku, Fcrepo and Solr. They are  **_not_** production-ready.

## Vagrant

### Blacklight

To deploy a Centos7 VirtualBox with Blacklight, using Vagrant:

```
cd blacklight
vagrant up
```

### Hyrax

To deploy a Centos7 VirtualBox with Hyrax, using Vagrant:

```
cd hyrax
vagrant up
```

### Hyku

To deploy a Centos7 VirtualBox with Hyku, using Vagrant:

```
cd hyku
vagrant up
```

Before running, check, the variables at the top of `provision_hyku_local.sh` and `provision_scripts\provision_phantomjs.sh`

### Solr AWS (Centos7)

To deploy a Centos7 AWS Box with solr, using Vagrant:

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

Before running, check, the variables at the top of `provision_solr_centos7.sh`

### Hyku AWS (Centos7)

To deploy a Centos7 AWS Box with Hyku, using Vagrant:

Edit the following to provide the solr and fedora uri and paths:

* install_files/rbenv-vars

add the variables at the top of; check the solr URI is correct:

* provision_hyku_aws.sh

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

```
cd aws_hyku
vagrant up --no-provision
```

This will create the box, but won't run the provisioning scripts. We need the machine ip address in order to fully provision.

Once the machine is running, find it's ip address and do the following:

1. Add it into an AWS security group to enable the fedora and solr servers to receive requests from this IP.
2. Edit the following files in install_files with the new ip address:

* install_files/hyku.conf
* install_files/hyku_ssl.conf
* install_files/hyku_ssl_passenger.conf
* install_files/sp2config.xml
* Metadataforshibhykutesting

The current text is set as REPLACE_ME ... so a find and replace on that will suffice.

Before running, check, the variables at the top of `provision_hyku_aws.sh`

Note: `Metadataforshibhykutesting` is a sample of the shibboleth metadata that can be used for testing with testshib.org. 

### Provision Scripts

The scripts in the 'provision_scripts' folder are used by the vagrant installations. They can also be used standalone.

For Hyku:

* provision_prereq.sh
* provision_postgres.sh
* provision_hyrax.sh
* provision_phantom.js (requires the correct version to be set as a variable in the script)
* provision_shib.sh
* provision sidekiq.sh
* provision_postgres.sh
* provision_passenger.sh

* provision_solr_centos7.sh (requires the solr version to be set as a variable in the script)


### Fedora local or AWS (Ubuntu)

Lightly modified Vagrantfile from https://github.com/VTUL/fcrepo4-ansible

* Checkout https://github.com/VTUL/fcrepo4-ansible
* Replace the Vagrant file with this one
* Create an .env file as per Hyku AWS

## Other Scripts

### provision_hyrax_ubuntu.sh 

incomplete script to run ulcc_hyrax on ubuntu 16.04

