
FROM ubuntu:xenial
# Since we don't have a tty , this fix avoids warning and errors
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get upgrade -y
RUN apt-get install apt-utils git sudo wget -y

# Dependencies for ubuntu 16.04
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get install -y autoconf automake debhelper
RUN apt-get install -y pkg-config libreadline-dev libtool
RUN apt-get install -y sqlite3 libsqlite3-dev
RUN apt-get install -y libusb-1.0-0 libusb-1.0-0-dev
RUN apt-get install -y libortp-dev libortp9
RUN apt-get install -y libosip2-dev
RUN apt-get install -y libncurses5 libncurses5-dev
RUN apt-get install -y libvolk1-bin libvolk1-dev
RUN volk_profile

# libsqliteodbc deps
RUN apt-get install -y cdbs libsqlite0-dev

# asterisk deps
RUN apt-get install -y unixodbc unixodbc-dev libsqliteodbc
RUN apt-get install -y libssl-dev
RUN apt-get install -y libsrtp0 libsrtp0-dev
RUN apt-get install -y uuid-dev
RUN apt-get install -y libjansson-dev libxml2-dev
# zmq
RUN apt-get install -y libzmq3-dev libzmq5 python-zmq
# USRP B210
RUN apt-get install -y libuhd-dev libuhd003 uhd-host
RUN uhd_images_downloader
#range-configs
RUN apt-get install -y ntp ntpdate bind9
# fetching sources & building process
RUN git clone https://github.com/RangeNetworks/dev.git /opt/dev
WORKDIR "/opt/dev"
RUN ./clone.sh
RUN git pull
RUN ./pull.sh
#RUN ./build.sh B210

#WORKDIR "/opt/dev/BUILDS/`date +\"%Y\"`*"
#RUN dpkg -i libcoredumper*.deb
#RUN apt-get install -f
#RUN dpkg -i liba53*.deb
#RUN apt-get install -f
#RUN dpkg -i range-configs*.deb
#RUN apt-get install -f
#RUN dpkg -i range-asterisk*.deb
#RUN apt-get install -f
#RUN dpkg -i sipauthserve*.deb
#RUN apt-get install -f
#RUN dpkg -i smqueue*.deb
#RUN apt-get install -f
#RUN dpkg -i openbts*.deb
#RUN apt-get install -f
#RUN apt-get autoremove


# sudo docker run --tty --interactive openbts
