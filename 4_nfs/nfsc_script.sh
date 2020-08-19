#!/bin/bash

yum install nfs-utils nano -y



# mount -t nfs 192.168.50.10:/var/nfs_share /mnt
# umount -l /mnt
# mount | grep nfs
# showmount -e 192.168.50.10
mkdir -p /mnt/share
cp /vagrant/mnt-share.mount /etc/systemd/system/
systemctl start mnt-share.mount
systemctl enable mnt-share.mount
