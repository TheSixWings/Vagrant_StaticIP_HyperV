#!/bin/sh

## defaults
prefix="24"
dns="8.8.8.8"

while getopts ":p:d:i:" opt; do
  case $opt in
    p) prefix="$OPTARG"
    ;;
    d) dns="$OPTARG"
    ;;
    i) ip="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

gateway() {
  echo `echo $ip | cut -d "." -f1-3`.1
}

echo 'Setting static IP address for Hyper-V...'

cat << EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: no
      addresses: [$ip/$prefix]
      gateway4: $(gateway)
      nameservers:
        addresses: [$(gateway),$dns]
EOF

# Be sure NOT to execute "netplan apply" here, so the changes take effect on
# reboot instead of immediately, which would disconnect the provisioner.