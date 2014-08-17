#!/bin/sh
# -*- coding: utf-8 -*-

# change mount parameter
sed -i "/mysql/s/defaults/defaults,noatime,barrier=0/" /etc/fstab

# turn off iptables on startup
service iptables stop
chkconfig iptables off
chkconfig ip6tables off

# create mysql user
if ! grep -q mysql /etc/passwd;then
    groupadd mysql
    useradd -g mysql mysql -s /sbin/nologin
fi
 
# create soft dir if not exist
if [ ! -e /other/software ];then
    mkdir -p /other/software/
fi

# get and copy mysql bin
if [ ! -e /other/software/mysql-5.5.31-linux2.6-x86_64.tar.gz ];then
    cd /other/software/
    wget -SO mysql-5.5.31-linux2.6-x86_64.tar.gz http://192.168.1.7/mysql-5.5.31-linux2.6-x86_64.tar.gz
    tar zxf mysql-5.5.31-linux2.6-x86_64.tar.gz
fi
if [ ! -e /usr/local/mysql/bin ];then
    mv mysql-5.5.31-linux2.6-x86_64/* /usr/local/mysql/
    mkdir /usr/local/mysql/log
    chown -R mysql:mysql /usr/local/mysql 
fi

# create data dirs
for dir in data innodb logs
do
    if [ ! -e /usr/mysqldata/${dir} ];then
        mkdir /usr/mysqldata/${dir}
    fi
done
chown -R mysql:mysql /usr/mysqldata

# initial and start mysql
cd /usr/local/mysql && ./scripts/mysql_install_db --user=mysql
