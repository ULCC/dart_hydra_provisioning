#!/bin/bash

SOLR="6.4.1"

yum -y update
yes | sudo yum install -y java-1.8.0-openjdk.x86_64 wget unzip lsof

cd
wget http://apache.mirror.anlx.net/lucene/solr/$SOLR/solr-$SOLR.tgz
tar -xvf solr-$SOLR.tgz
mv solr-$SOLR /opt/solr

cd /opt/solr/
bin/solr start
bin/solr create -c hyrax
cd server/solr/hyrax/conf
mv solrconfig.xml solrconfig.xmlBAK
wget https://raw.githubusercontent.com/projecthydra-labs/hyrax/master/solr/config/solrconfig.xml
wget https://raw.githubusercontent.com/projecthydra-labs/hyrax/master/solr/config/schema.xml
cd ../../../..
bin/solr restart
