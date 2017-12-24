#!/bin/bash
# (v0.7) OpenBTS installer script for Xubuntu 16.04 
# Deel - 2017 dec 24th - <deel:A:sortilege.io>
# Source : https://github.com/ax-el/USRP
################################################################
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
if [ ! -d ~/sdr ]; then
mkdir ~/sdr
fi
cd ~/sdr

sudo apt update && sudo apt upgrade -y
sudo apt install  -y

# Dependencies for ubuntu 16.04
sudo apt install -y software-properties-common python-software-properties
sudo apt install -y autoconf automake debhelper pkg-config libreadline-dev
sudo apt install -y sqlite3 libsqlite3-dev libusb-1.0-0 libusb-1.0-0-dev
sudo apt install -y libortp-dev libortp9 libosip2-dev libtool apt-utils git wget
sudo apt install -y libvolk1-bin libvolk1-dev libncurses5 libncurses5-dev
volk_profile

# libsqliteodbc deps
sudo apt install -y cdbs libsqlite0-dev
# asterisk deps
sudo apt install -y unixodbc unixodbc-dev libsqliteodbc libsrtp0 libsrtp0-dev
sudo apt install -y libjansson-dev libxml2-dev uuid-dev libssl-dev
# zmq deps
sudo apt install -y libzmq3-dev libzmq5 python-zmq
# USRP B210 deps
sudo apt install -y libuhd-dev libuhd003 uhd-host
# Get UHD images for B210
sudo uhd_images_downloader
#range-configs deps
sudo apt install -y ntp ntpdate bind9

# fetching sources & building process
basedir=~/sdr/dev
git clone https://github.com/RangeNetworks/dev.git $basedir
cd $basedir
./clone.sh
git pull
./pull.sh
sudo ./build.sh B210
# Deb Packages are built in a timestamped folder
cd $basedir/BUILDS/*--*
sudo dpkg -i libcoredumper*.deb
sudo apt install -f
sudo dpkg -i liba53*.deb
sudo apt install -f

# TODO : check if /etc/bind/named.conf.options and /etc/default/bind9 deserves to be edited by the script
sudo dpkg -i range-configs*.deb
sudo apt install -f
# TODO : check if /etc/odbcinst.ini deserves to be edited by the script
sudo dpkg -i range-asterisk*.deb
sudo apt install -f
sudo dpkg -i sipauthserve*.deb
sudo apt install -f
sudo dpkg -i smqueue*.deb
sudo apt install -f
sudo dpkg -i openbts*.deb
sudo apt install -f
sudo apt autoremove
