# part 1 ( reset root pass )
при загрузке e

Способ 1. init=/bin/sh

linux16 -> init=/bin/sh ctrl-x
mount -o remount,rw /
mount | grep root

Способ 2. rd.break

rd.break -> ctrl-x
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel

Отличие от метода init =/bin/sh: мы попадаем в среду initrd, а корневая FS монтируется в каталог / sysroot.


Способ 3. rw init=/sysroot/bin/sh
ro -> rw init=/sysroot/bin/sh ctrl-x

# part 2 (rename vg)

sudo vgs

sudo vgrename centos OtusRoot

sudo sed -i.old 's#^/dev/mapper/centos-#/dev/mapper/OtusRoot-#g' /etc/fstab
cat /etc/fstab

sudo sed -i.old 's#lvm.lv=centos/#lvm.lv=OtusRoot/#g' /etc/default/grub
cat /etc/default/grub

sudo sed -i.old1 's#/dev/mapper/centos-#/dev/mapper/OtusRoot-#g' /boot/grub2/grub.cfg
sudo sed -i.old2 's#lvm.lv=centos/#lvm.lv=OtusRoot/#g' /boot/grub2/grub.cfg
sudo cat /boot/grub2/grub.cfg


sudo mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

sudo reboot

sudo vgs

# part 3 (add module to initrd)


sudo mkdir -p /usr/lib/dracut/modules.d/01test
curl --silent https://gist.githubusercontent.com/lalbrekht/e51b2580b47bb5a150bd1a002f16ae85/raw/80060b7b300e193c187bbcda4d8fdf0e1c066af9/gistfile1.txt | sudo tee /usr/lib/dracut/modules.d/01test/module-setup.sh
curl --silent https://gist.githubusercontent.com/lalbrekht/ac45d7a6c6856baea348e64fac43faf0/raw/69598efd5c603df310097b52019dc979e2cb342d/gistfile1.txt | sudo tee /usr/lib/dracut/modules.d/01test/module-setup.sh
sudo chmod +x /usr/lib/dracut/modules.d/01test/module-setup.sh
<!-- mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r) -->
sudo dracut -f -v

sudo lsinitrd -m /boot/initramfs-$(uname -r).img | grep test

sudo sed -i.old 's/ rhgb quiet//g' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg