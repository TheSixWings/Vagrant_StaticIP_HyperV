#!/bin/sh
#Place to D:\Vagrant\
#Example: bash init.sh -n Java-TEST-WIN -i 192.168.30.3 -b gusztavvargadr/windows-server -a 'D:\Ansible' -v '/mnt/d/vagrant'
## defaults
name="Server01-TEST-WIN"
ip="192.168.30.4"
box="gusztavvargadr/windows-server"
ansible="D:\Ansible"
vagrant="/mnt/d/vagrant"

while getopts "n:i:b:a:v:" opt
do
  case $opt in
    n) name="$OPTARG";;
    i) ip="$OPTARG";;
    b) box="$OPTARG";;
    a) ansible="$OPTARG";;
    v) vagrant="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2;;
  esac
done

echo 'Clone from Github'
cd ~
git clone https://github.com/TheSixWings/Vagrant_StaticIP_HyperV
echo 'Rename to '$name
mv Vagrant_StaticIP_HyperV $name
echo 'Modify Vagrantfile'
box=$(echo $box | sed 's/\//\\\//')
ansible=$(echo $ansible | sed 's/\\/\\\\\\\\/')
sed -i 's/HOSTNAME = \"Server01-TEST-WIN\"/HOSTNAME = \"'$name'\"/' $name/Vagrantfile
sed -i 's/StaticIP = \"192.168.30.4\"/StaticIP = \"'$ip'\"/' $name/Vagrantfile
sed -i 's/BOX = \"gusztavvargadr\/windows-server\"/BOX = \"'$box'\"/' $name/Vagrantfile
sed -i 's/Ansible = \"D:\\\\Ansible\"/Ansible = \"'$ansible'\"/' $name/Vagrantfile
mv ~/$name $vagrant/$name
rm -rf $vagrant/$name/.git*
rm -r $vagrant/$name/init.sh
rm -rf ~/$name
echo ''
echo ''
echo '-------------------------------'
echo 'Vagrant box: '$name
echo 'Initialization Complete'
echo 'To start, try:'
echo '  cd '$name'; vagrant up'
echo '-------------------------------'
echo ''
echo ''