# dart_hydra_provisioning
Hydra Provisioning Scripts

These scripts are for **_development_** instances only.

##Vagrant

To deploy a Centos7 Virtual Box with Hyku and ULCC_Hyrax, using Vagrant:

```
cd vagrant
vagrant up
```

The following scripts can be run standalone from any CentosBox to deploy either Hyku or ULCC_Hyrax:

```
vagrant\provision_hyku.sh
vagrant\provision_hyrax.sh
```

##Other Scripts

Contains an incomplete script for setting up Ubuntu 16.04 with everything needed to run Hyku.