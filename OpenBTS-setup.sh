#!/bin/bash
# (v0.6) OpenBTS installer script for Xubuntu 16.04 
# Deel - 2017 june 9th - <deel:A:sortilege.io>
# Source : https://github.com/ax-el/USRP
################################################################
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
if [ ! -d ~/sdr ]; then
mkdir ~/sdr
fi
cd ~/sdr
git clone https://github.com/RangeNetworks/dev.git
basedir=~/sdr/dev
cd $basedir
./clone.sh
#./switchto.sh master
# Required dependencies
#sudo apt install -y autoconf libtool libosip2-dev libortp-dev  
#sudo apt install -y libusb-1.0-0-dev g++ sqlite3 libsqlite3-dev
#sudo apt install -y erlang libreadline6-dev libncurses5-dev
# A special library is required, it's part of the package
#cd $basedir/liba53
#sudo make install
# Since we are building openBTS for a B210 card
#valid radio types would be: SDR1, USRP1, B100, B110, B200, B210, N200, N210"
#cd $basedir
git pull
./pull.sh
./build.sh B210

# Configure OpenBTS
sudo mkdir /etc/OpenBTS
sudo sqlite3 -init $basedir/openbts/apps/OpenBTS.example.sql /etc/OpenBTS/OpenBTS.db ".quit"
cd $basedir/openbts/apps
ln -s $basedir/openbts/Transceiver52M/transceiver .

# Get UHD images for B210
sudo uhd_images_downloader

# Now we need to make a subscriber Registry and setup Sipauthserve
sudo mkdir -p /var/lib/asterisk/sqlite3dir
sudo sqlite3 -init $basedir/subscriberRegistry/apps/subscriberRegistry.example.sql /etc/OpenBTS/sipauthserve.db ".quit"

#Now we need to setup smqueue
sudo sqlite3 -init $basedir/smqueue/smqueue/smqueue.example.sql /etc/OpenBTS/smqueue.db ".quit"
sudo mkdir /var/lib/OpenBTS
sudo touch /var/lib/OpenBTS/smq.cdr

# Deb Packages are built in a timestamped folder
cd $basedir/BUILDS/*--*
sudo dpkg -i *.deb
sudo apt-get -f install
