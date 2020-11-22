#!/bin/bash


yum install -y yum-utils
yum install nano wget unzip -y

sudo yum -y install http://download.zfsonlinux.org/epel/zfs-release.el8_2.noarch.rpm
gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
yum-config-manager --enable zfs-kmod
yum-config-manager --disable zfs
yum install -y zfs
modprobe zfs
#zpool create poolmirror mirror sdb sdc
# echo disk{1..6} | xargs -n 1 fallocate -l 500M
# zpool create stripe $PWD/disk[1-5]
# zpool create mir mirror $PWD/disk[1-5]
# zpool create raid raidz1 $PWD/disk[1-3]
# zpool create raid raidz2 $PWD/disk[1-2]
# zpool create raid raidz3 $PWD/disk[1-3] # less disks
# zpool create raid raidz3 $PWD/disk[1-5]
# zpool create striping sdb sdbc sdd

# zpool create tank mirror sde sfd mirror sfg sdh
# zfs create tank/test2


# ФС создается поверх пула
# zfs create storage/userdir
# zfs create storage/data
# ФС Может быть вложенной
# zfs create storage/data/video
# zfs create storage/data/music

# raid-0 fast raidz-3 slowest
# zfs get mounted
# zfs create striping/src
# zfs create striping/src/compressed
# zfs set compression=on striping/src/compressed
# zfs set compress=lz4 striping/src/compressed
# zfs get compression,compressratio





# sudo zpool create zpool sdf
# sudo zpool status
# echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo zfs create -o compression={} zpool/{}
# zfs list
# echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo zfs get compression zpool/{} | grep compression
# wget http://mattmahoney.net/dc/enwik8.zip
# unzip enwik8.zip
# cd /
# echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo cp enwik8 /zpool/{}/
# echo -n gzip gzip-{1..9} lz4 lzjb zle | xargs -d" " -I{} sudo zfs get compressratio zpool/{} | grep compressratio



