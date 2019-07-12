#!/bin/bash

echo "Install samba"
sudo apt update
sudo apt install samba
whereis samba

# echo "create samba share"
#mkdir /home/<username>/sambashare

# edit the config file
# sudo nano /etc/samba/smb.conf
# add these  lines
#[sambashare]
#    comment = Samba on Ubuntu
#    path = /home/username/sambashare
#    read only = no
#    browsable = yes

#sudo service smbd restart
#sudo smbpasswd -a username


# connect to server smb://<ip-address>/sambashare

