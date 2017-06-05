# dart_hydra_provisioning
Hydra Provisioning Scripts

These scripts are for **_development_** instances only.

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
vagrant up --provider=aws
```

As soon as the ip address for the new box is available, add it to the security groups in AWS otherwise you won't be able to update solr or fedora.

### Provision Scripts

The scrips in the 'provision_scripts' folder are used by the vagrant installations. They can also be used standalone.

* provision_prereq.sh

```
FITS="1.0.2"
RUBY="2.3.3"
RAILS="5.0.3"
USER=vagrant
```

* provision_postgres.sh

* provision_hyrax.sh

* provision_phantom.js

```
PHANTOM="phantomjs-2.1.1-linux-x86_64"
```

* provision_solr_centos7.sh

```
SOLR="6.5.2"
```

### Fedora local or AWS (Ubuntu)

Lightly modified Vagrantfile from https://github.com/VTUL/fcrepo4-ansible

* Checkout https://github.com/VTUL/fcrepo4-ansible
* Replace the Vagrant file with this one
* Create an .env file as per Hyku AWS

## Other Scripts

### provision_hyrax_ubuntu.sh 

incomplete script to run ulcc_hyrax on ubuntu 16.04

