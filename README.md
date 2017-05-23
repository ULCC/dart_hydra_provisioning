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

The following script can be run standalone from any CentosBox to deploy Hyku:

```
hydra\provision_hyku.sh
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

add the solr uri and set admin_host to the ip address of the server in here:

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

```
cd aws_hyku
vagrant up --provider=aws
```

To run in production, change the RAILS_MODE variable to 'production' at the top of provision_hyku.sh.

### Fedora local or AWS (Ubuntu)

Lightly modified Vagrantfile from https://github.com/VTUL/fcrepo4-ansible

* Checkout https://github.com/VTUL/fcrepo4-ansible
* Replace the Vagrant file with this one
* Create an .env file as per Hyku AWS

## Other Scripts

### provision_hyrax_ubuntu.sh 

incomplete script to run ulcc_hyrax on ubuntu 16.04

