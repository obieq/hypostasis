#!/bin/bash

apt-get -y install curl git

wget https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement/1.0.1/foundationdb-clients_1.0.1-1_amd64.deb
wget https://foundationdb.com/downloads/I_accept_the_FoundationDB_Community_License_Agreement/1.0.1/foundationdb-server_1.0.1-1_amd64.deb

sudo dpkg -i foundationdb-clients_1.0.1-1_amd64.deb foundationdb-server_1.0.1-1_amd64.deb

sudo su - vagrant
cd /home/vagrant
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm
rvm install ruby-2.0.0-p353

cd /vagrant; bundle
