# dart_hydra_provisioning
Hydra Provisioning Scripts for deploying Hyku, Fcrepo and Solr. They are  **_not_** production-ready.

## Vagrant

Each of the following folders contains a Vagrantfile for bringing up a local or AWS box using vagrant. There are various configuration settings in the Vagrantfile that may need changing for your environment. Eg. for the amount of RAM given to the box, or the AWS box (t1.micro etc.).

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

This script take a while and installs Hyku in a production-like way, with apache, passenger and other things. But it still uses solr_wrapper and fcrepo_wrapper which are not intended for production. To change what is installed, edit the list of scripts in the Vagrant file.

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

Create the following to provide the solr and fedora uri and paths using .rbenv-vars-template as a guide:

* install_files/.rbenv-vars

add the variables at the top of this file including the the solr URI:

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

### Fedora4 AWS (Ubuntu)

vagrant_for_fcrepo4-ansible/fcrepo4 contains a modified Vagrantfile from https://github.com/VTUL/fcrepo4-ansible

* vagrant plugin install vagrant-aws
* Checkout https://github.com/VTUL/fcrepo4-ansible
* Replace the Vagrant file with this vagrant_for_fcrepo4-ansible/fcrepo4/Vagrantfile
* Create an .env file containing

```
KEYPAIR_NAME=""
KEYPAIR_FILE=""
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
AWS_SECURITY_GROUPS=""
AWS_SUBNET=""
```

Note: If running on Windows, Ansible is not supported (there are ways round this, with cygwin and the Linux subsystem 
for Windows) but as an alternative vagrant_for_fcrepo4-ansible contains a Vagrantfile for a centosbox that will install 
vagrant and ansible - this can be used to run the vagrant up/provision. It's not ideal, but it works!
 
## Provision Scripts

The scripts in the 'provision_scripts' folder are used by the vagrant installations. They can also be used standalone.

* provision_prereq.sh (set the fits and ruby versions at the top of the script, the domain/ip )
* provision_postgres.sh
* provision_phantom.js (requires the correct version to be set as a variable in the script)
* provision_shib.sh (set the domain/ip at the top of the file)
* provision sidekiq.sh
* provision_postgres.sh
* provision_passenger.sh

* provision_solr_centos7.sh (requires the solr version and user to be set as a variable in the script)

## Other Scripts

### provision_hyrax_ubuntu.sh 

incomplete and rough script to run dart_hyrax on ubuntu 16.04

## Running on windows

If you get the error `No synced folder implementation is available for your synced folders`, a quick solution is 
`vagrant plugin install vagrant-winnfsd` or figure out how to install rsync I guess.


