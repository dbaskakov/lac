#!/bin/bash

yum install -y redhat-lsb-core wget rpmdevtools nano rpm-build createrepo yum-utils tree

sudo -u vagrant wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

sudo -u vagrant rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

sudo -u vagrant wget https://www.openssl.org/source/latest.tar.gz
sudo -u vagrant tar -xvf latest.tar.gz
sudo yum-builddep --assumeyes rpmbuild/SPECS/nginx.spec
sudo -u vagrant sed -i 's#--with-debug#--with-openssl=/home/vagrant/openssl-1.1.1g#g' rpmbuild/SPECS/nginx.spec




sudo -u vagrant rpmbuild -bb rpmbuild/SPECS/nginx.spec


yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm

systemctl start nginx

systemctl status nginx

mkdir -p /usr/share/nginx/html/repo

cp /home/vagrant/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
createrepo /usr/share/nginx/html/repo/

#В location / в файле /etc/nginx/conf.d/default.conf добавим директиву autoindex on
sed -i '/index.htm;.*/a \        autoindex on;' /etc/nginx/conf.d/default.conf

sudo nginx -t && sudo nginx -s reload

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

service docker start