#!/bin/bash

if ! [[ $(cat /etc/os-release | grep -w ID | sed 's/ID=//g' | head -n1) ==  'debian' ]]; then
  echo "Installer ini dibuat untuk OS debian"
  exit
fi

# >> Update repository
apt update -y; apt upgrade -y

# >> Install required packages
apt install build-essential cmake libpcap-dev libpcre3-dev zlib1g-dev libluajit-5.1-dev libssl-dev libdaq-dev pkg-config git tshark net-tools -y

# >> Install snort
git clone https://github.com/snort3/snort3.git
cd snort3
./configure_cmake.sh --prefix=/usr/local/snort
cd build
make -j$(nproc)
make install

# >> Salin Config default
mkdir -p /etc/snort/rules
cp -r etc/* /etc/snort/
