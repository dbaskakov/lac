#!/bin/bash

# for i in {1..5};
# do
#   sgdisk -n ${i}:0:+100M /dev/md/raid1
# done
cp /vagrant/raid-part{1..5}.mount /etc/systemd/system/
yum install -y mdadm smartmontools hdparm gdisk parted
mdadm --create /dev/md127 --level=1 --raid-devices=2 /dev/sdd /dev/sde --metadata=0.90
parted -s /dev/md127 mklabel gpt

parted /dev/md127 mkpart primary ext4 0% 20%
parted /dev/md127 mkpart primary ext4 20% 40%
parted /dev/md127 mkpart primary ext4 40% 60%
parted /dev/md127 mkpart primary ext4 60% 80%
parted /dev/md127 mkpart primary ext4 80% 100%

 for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md127p$i; done

 mkdir -p /raid/part{1,2,3,4,5}


systemctl start raid-part{1..5}.mount
systemctl enable raid-part{1..5}.mount