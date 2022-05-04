#!/bin/bash
## defaults
example="Example: Destroy: './Destroy.sh -f', Restore: './Destroy.sh -r'"

while getopts ":f:r:" opt
do
  case $opt in
    f) args=$OPTARG ;;
    r) args=$OPTARG ;;
    \?) echo "Invalid option -"$OPTARG >&2; exit 1;;
  esac
done
if [ $OPTIND -eq 1 ]; then echo $example && exit 1; fi
if [[ $1 == "-f" ]]
then
  echo 'Destroy Vagrant box'
  line=`wc -l < Vagrantfile`
  line=$(expr $line - 6)
  cp Vagrantfile Vagrantfile.bak
  sed ''$line','$(expr $line + 5)'d' Vagrantfile.bak > Vagrantfile
  vagrant destroy -f
elif [[ $1 == "-r" ]]
then
  echo 'Restore Vagrantfile'
  cp Vagrantfile.bak Vagrantfile
fi