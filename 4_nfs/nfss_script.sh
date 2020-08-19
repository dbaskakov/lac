#!/bin/bash

mkdir -p /var/nfs_share
mkdir -p /var/nfs_share/upload
yum install nfs-utils -y
echo '/var/nfs_share/  192.168.50.11(rw,async)' >> /etc/exports
echo '/var/nfs_share/upload  192.168.50.11(rw,async)' >> /etc/exports
systemctl enable nfs-server
service nfs-server start
service firewalld start
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=nfs3
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload
#nfsstat -c