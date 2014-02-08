#!/bin/bash

apt-get -y install curl git

wget https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement/2.0.0/foundationdb-clients_2.0.0-1_amd64.deb
wget https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement/2.0.0/foundationdb-server_2.0.0-1_amd64.deb

sudo dpkg -i foundationdb-clients_2.0.0-1_amd64.deb foundationdb-server_2.0.0-1_amd64.deb

sudo su - vagrant
cd /home/vagrant
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm
rvm install jruby

cd /vagrant; rvm all do bundle
