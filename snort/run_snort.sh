#!/bin/bash

# https://cyberpersons.com/2016/07/18/install-snort-ubuntu/

echo "====================================="
echo "Update"

sudo apt-get update
sudo apt-get dist-upgrade

sudo apt-get install build-essential
sudo apt-get install -y libpcap-dev libpcre3-dev libdumbnet-dev
sudo apt-get install -y zlib1g-dev liblzma-dev openssl libssl-dev
sudo apt-get bison flex

echo "====================================="
echo "dag"

cd ~/snort
wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz
tar -xvzf daq-2.0.6.tar.gz
cd daq-2.0.6
./configure
make
sudo make install

echo "====================================="
echo "snort"
cd ~/snort
wget https://www.snort.org/downloads/snort/snort-2.9.8.3.tar.gz
tar -xvzf snort-2.9.8.3.tar.gz
cd snort-2.9.8.3
./configure
make
sudo make install
sudo ldconfig
sudo ln -s /usr/local/bin/snort /usr/sbin/snort

echo "====================================="
echo "groupadd"
sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
 
sudo mkdir /etc/snort
sudo mkdir /etc/snort/rules
sudo mkdir /etc/snort/rules/iplists
sudo mkdir /etc/snort/preproc_rules
sudo mkdir /usr/local/lib/snort_dynamicrules
sudo mkdir /etc/snort/so_rules

echo "====================================="
echo "snort rules"
sudo touch /etc/snort/rules/iplists/black_list.rules
sudo touch /etc/snort/rules/iplists/white_list.rules
sudo touch /etc/snort/rules/local.rules
sudo touch /etc/snort/sid-msg.map
 
 
sudo mkdir /var/log/snort
sudo mkdir /var/log/snort/archived_logs
 
echo "====================================="
echo "chmod" 
sudo chmod -R 5775 /etc/snort
sudo chmod -R 5775 /var/log/snort
sudo chmod -R 5775 /var/log/snort/archived_logs
sudo chmod -R 5775 /etc/snort/so_rules
sudo chmod -R 5775 /usr/local/lib/snort_dynamicrules
 
 
 
sudo chown -R snort:snort /etc/snort 
sudo chown -R snort:snort /var/log/snort 
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules
 
cd ~/snort/snort-2.9.8.3/etc/ 
sudo cp *.conf* /etc/snort 
sudo cp *.map /etc/snort 
sudo cp *.dtd /etc/snort 
cd ~/snort/snort-2.9.8.3/src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/ 
sudo cp * /usr/local/lib/snort_dynamicpreprocessor/

sudo sed -i "s/include \$RULE\_PATH/#include \$RULE\_PATH/" /etc/snort/snort.conf

# Test Snort
# insert a rule in our “/etc/snort/rules/local.rules” file.
echo "====================================="
echo "snort test"
alert ip any any -&gt; any any (msg:"ATTACK RESPONSES id check returned root"; content: "uid=0(root)"; classtype:bad-unknown;
sid:498; rev:3;)

sudo snort -A console -q -u snort -g snort -c /etc/snort/snort.conf -i ens3

ping -b 255.255.255.255 -p "7569643d3028726f6f74290a" -c3

