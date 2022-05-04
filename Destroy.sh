#!/bin/sh
## defaults
example="Example: ./Destroy.sh -f"

while getopts ":f:" opt
do
  case $opt in
    f) force="$OPTARG" ;;
    \?) echo "Invalid option -"$OPTARG >&2; exit 1;;
  esac
done
if [ $OPTIND -eq 1 ]; then echo $example && exit 1; fi

echo 'Destroy Vagrant box'
line=`wc -l < Vagrantfile`
line=$(expr $line - 6)
cp Vagrantfile Vagrantfile.bak
sed ''$line','$(expr $line + 5)'d' Vagrantfile.bak > Vagrantfile
vagrant destroy -f