# Tiny Core on VirtualBox

The goal of this procedure is to obtain an OVA file of a [Tiny Core Linux](http://tinycorelinux.net/) guest under [VirtualBox](https://www.virtualbox.org/).

This procedure was tested successfully with the following configuration:

- OSX 10.11.3
- VirtualBox 5.0.16-105871
- GNU bash, version 4.3.42(1)-release (x86\_64-apple-darwin15.0.0)

All commands to be executed on the **host** or through *ssh* on **guest** side can just be copy/pasted to the terminal (select the whole block of commands).

Some accommodations might be relevant depending on the actual configuration it is operated on.

## VM setup

On the VirtualBox **host**:
```bash
curl -O http://tinycorelinux.net/7.x/x86_64/release/CorePure64-7.0.iso
VBoxManage createvm --name C0r3 --ostype Linux26_64 --register
VBoxManage modifyvm C0r3 --vram 10
VBoxManage storagectl C0r3 --name SATA --add sata --controller IntelAhci --portcount 1 --bootable on
VBoxManage createhd --filename "$(VBoxManage list systemproperties | awk -F ': +' '/^Default machine folder/{print $2}')/C0r3/C0r3.vdi" --size 512
VBoxManage storageattach C0r3 --storagectl SATA --port 0 --type hdd --medium "$(VBoxManage list systemproperties | awk -F ': +' '/^Default machine folder/{print $2}')/C0r3/C0r3.vdi"
VBoxManage storagectl C0r3 --name IDE --add ide --bootable on
VBoxManage storageattach C0r3 --storagectl IDE --port 0 --device 0 --type dvddrive --medium CorePure64-7.0.iso
VBoxManage modifyvm C0r3 --nic1 nat --nictype1 virtio
VBoxManage modifyvm C0r3 --natpf1 "ssh,tcp,,7103,,22"
VBoxManage startvm C0r3
```

Once the **Tiny Core guest** presents the `boot:` prompt press the enter key or wait a few seconds until the kernel boots.

## SSH access

Enter the following commands once the **Tiny Core** shell prompt is displayed (`tc@box:~$`)
```sh
tce-load -wi openssh
cd /usr/local/etc/ssh
sudo cp sshd_config.example sshd_config
sudo /usr/local/etc/init.d/openssh start
passwd
```
The last command will prompt for a new passwd for the *tc* user, this is mandatory in order for *ssh* to accept connections with this user.

Login from the **host** to the **guest** through *ssh*:
```bash
ssh -p 7103 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no tc@127.0.0.1
```

## Hard drive install

Once the *ssh* log in is successful:
```sh
sudo fdisk /dev/sda << EOS
n
p
1


t
83
w
EOS
sudo mkfs.ext3 /dev/sda1
sudo rebuildfstab
mount /mnt/sda1
mount /mnt/sr0
sudo mkdir -p /mnt/sda1/boot/grub
sudo cp -p /mnt/sr0/boot/* /mnt/sda1/boot/
sudo mkdir -p /mnt/sda1/tce
tce-load -wi grub2-multi
sudo cp -p /usr/local/lib/grub/x86_64-efi/* /mnt/sda1/boot/grub/
sudo mv /mnt/sda1/boot/vmlinuz64 /mnt/sda1/boot/vmlinuz-64-core-7.0
sudo mv /mnt/sda1/boot/corepure64.gz /mnt/sda1/boot/initrd-64-core-7.0.gz
for i in bin dev etc lib proc run sbin sys tmp usr var; do sudo mkdir /mnt/sda1/$i; sudo mount --bind /$i /mnt/sda1/$i; done
for i in /tmp/tcloop/*; do sudo mount --bind $i /mnt/sda1$i; done
sudo chroot /mnt/sda1
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
for i in /mnt/sda1/tmp/tcloop/*; do sudo umount $i; done
for i in bin dev etc lib proc run sbin sys tmp usr var; do sudo umount /mnt/sda1/$i; sudo rmdir /mnt/sda1/$i; done
cat << EOS | sudo tee -a /opt/.filetool.lst
/etc/shadow
/usr/local/etc/ssh
EOS
cat << EOS | sudo tee -a /opt/bootsync.sh
/usr/local/etc/init.d/openssh start
EOS
sudo tar cf - -C /tmp/tce . | sudo tar xf - -C /mnt/sda1/tce
filetool.sh -b /dev/sda1/tce
sudo poweroff
```

## Finalize

Once the *ssh* session is closed:
```bash
VBoxManage storagectl C0r3 --name IDE --remove
VBoxManage export C0r3 --output C0r3.ova --options manifest
VBoxManage unregistervm C0r3 --delete
```

## Sources

This procedure was mostly inspired by:

- [First attempt to install Tiny Core Linux to hard disk](https://firewallengineer.wordpress.com/2013/07/30/first-attempt-to-install-tiny-core-linux-to-hard-disk/)
- [How to install and configure OpenSSH (SSH Server) in Tiny Core Linux](https://firewallengineer.wordpress.com/2012/04/01/how-to-install-and-configure-openssh-ssh-server-in-tiny-core-linux/)
- [Persistent configuration changes in Tiny Core Linux](http://www.brianlinkletter.com/persistent-configuration-changes-in-tinycore-linux/)

And the [VirtualBox command line documentation](https://www.virtualbox.org/manual/ch08.html) also helped a lot.
