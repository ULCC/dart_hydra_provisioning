# dart_hydra_provisioning
Hydra Provisioning Scripts

These scripts are for **_development_** instances only.

##Vagrant

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

##Other Scripts


###provision_hyrax_ubuntu.sh 

incomplete script to run ulcc_hyrax on ubuntu 16.04

###provision_solr_centos.sh 

basic install of Solr with hyrax collection

