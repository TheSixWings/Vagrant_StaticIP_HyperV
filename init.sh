#!/bin/sh
#Place this file to D:\Vagrant\
#Example: bash init.sh -n Java-TEST-WIN -i 192.168.30.3 -b gusztavvargadr/windows-server -a 'D:\Ansible' -v '/mnt/d/vagrant' -c 4 -m 8192
## defaults
name="Server01-TEST-WIN"
ip="192.168.30.4"
box="gusztavvargadr/windows-server"
ansible="D:\Ansible"
vagrant="/mnt/d/vagrant"
cpus=2
memory=4096

while getopts ":n:i:b:a:v:c:m:" opt
do
  case $opt in
    n) name="$OPTARG" ;;
    i) ip="$OPTARG" ;;
    b) box="$OPTARG" ;;
    a) ansible="$OPTARG" ;;
    v) vagrant="$OPTARG" ;;
    c) cpu="$OPTARG" ;;
    m) memory="$OPTARG" ;;
    \?) echo "Invalid option -"$OPTARG >&2; exit 1;;
  esac
done
#set window size
lines="$(stty size | cut -d ' ' -f 1)"
printf '\033[8;%d;150t' $lines

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
sed -i 's/h.cpus = 2/h.cpus = '$cpu'/' $name/Vagrantfile
sed -i 's/h.memory = 4096/h.memory = '$memory'/' $name/Vagrantfile
echo 'Move to '$vagrant
mv ~/$name $vagrant/$name
#remove error
tput cuu 2
tput el
echo ''
tput el
echo ''
tput cuu 2
echo 'Clean up'
rm -rf $vagrant/$name/.git*
rm -r $vagrant/$name/init.sh
rm -rf ~/$name
tput setaf 2
echo ''
echo ''
echo '-------------------------------'
echo 'Vagrant box: '$(tput setaf 3)$name$(tput setaf 2)
echo 'CPU = '$(tput setaf 3)$cpu$(tput setaf 2)', Memory = '$(tput setaf 3)$memory$(tput setaf 2)
echo 'Initialization Complete'
echo 'To start, try:'$(tput setaf 7)
echo '  $cd '$name'; vagrant up'$(tput setaf 2)
echo '-------------------------------'
echo ''
echo ''
tput sgr 0