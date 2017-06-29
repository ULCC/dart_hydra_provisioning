#!/bin/bash

SOLR="6.6.0"

yum -y update
yes | sudo yum install -y java-1.8.0-openjdk.x86_64 wget unzip lsof

cd
if [ ! -d solr-$SOLR.tgz ]
then
    wget http://apache.mirror.anlx.net/lucene/solr/$SOLR/solr-$SOLR.tgz
    tar -xvf solr-$SOLR.tgz
else
    echo 'solr is already downloaded'
fi
rm solr-$SOLR.tgz
sudo mv solr-$SOLR /opt/solr

cd /opt/solr
bin/solr start
# Create a Collection
bin/solr create -c hyku
cd server/solr/hyku/conf
mv solrconfig.xml solrconfig.xmlBAK
wget https://raw.githubusercontent.com/projecthydra-labs/hyrax/master/solr/config/solrconfig.xml
wget https://raw.githubusercontent.com/projecthydra-labs/hyrax/master/solr/config/schema.xml

cd /opt/solr
bin/solr restart