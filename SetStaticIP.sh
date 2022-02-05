#!/bin/sh

echo 'Setting static IP address for Hyper-V...'

cat << EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.30.3/24]
      gateway4: 192.168.30.1
      nameservers:
        addresses: [192.168.30.1,8.8.8.8]
EOF

# Be sure NOT to execute "netplan apply" here, so the changes take effect on
# reboot instead of immediately, which would disconnect the provisioner.