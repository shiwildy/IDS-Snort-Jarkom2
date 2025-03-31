#!/bin/bash

if ! [[ $(cat /etc/os-release | grep -w ID | sed 's/ID=//g' | head -n1) ==  'debian' ]]; then
  echo "Installer ini dibuat untuk OS debian"
  exit
fi

read -p "Interface    : " intface
read -p "Network CIDR : " cidrnet

# >> Update repository
apt update -y; apt upgrade -y

# >> Install required packages
apt install build-essential cmake libpcap-dev libpcre3-dev zlib1g-dev libluajit-5.1-dev ethtool libssl-dev automake libtool flex liblzma-dev \
libhwloc-dev libpcre2-dev autoconf pkg-config git tshark net-tools screen psmisc -y

# >> Install libdaq
git clone https://github.com/snort3/libdaq.git
cd libdaq
./bootstrap
./configure
make -j $(nproc)
make install
ldconfig # >> update ldconfig
cd /root/ && rm -rf libdaq

# >> Install snort
git clone https://github.com/snort3/snort3.git
cd snort3
./configure_cmake.sh --prefix=/usr/local/snort
cd build
make -j $(nproc)
make install

# >> Buat folder untuk snort
mkdir -p /etc/snort/
mkdir -p /etc/snort/rules
mkdir -p /etc/snort/log
cd /root/ && rm -rf snort3

# >> Download snort config
wget -O /etc/snort/snort.lua 'https://raw.githubusercontent.com/shiwildy/IDS-Snort-Jarkom2/refs/heads/main/snort.lua'
wget -O /etc/snort/rules/local.rules 'https://raw.githubusercontent.com/shiwildy/IDS-Snort-Jarkom2/refs/heads/main/local.rules'

# >> Ubah ip network pada rules files
sed -i "s/cidrnet/$cidrnet/g" /etc/snort/rules/local.rules

# >> Buat services untuk nyalain promiscuos mode di interfaces
cat > /etc/systemd/system/snort-nic.service << END
[Unit]
Description=Set Snort 3 NIC in promiscuous mode and Disable GRO, LRO on boot
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ip link set dev $intface promisc on
ExecStart=/usr/sbin/ethtool -K $intface gro off lro off
TimeoutStartSec=0
RemainAfterExit=yes

[Install]
WantedBy=default.target
END

# >> Buat services untuk snort
cat > /etc/systemd/system/snort.service << END
[Unit]
Description=Snort IDS Daemon
After=network.target

[Service]
ExecStart=/usr/local/snort/bin/snort -i $intface -c /etc/snort/snort.lua -l /etc/snort/log
ExecReload=/usr/bin/killall snort
Restart=on-failure
User=root
Group=root

[Install]
WantedBy=multi-user.target
END

# >> Selesai
clear && echo -e $"Installasi telah selesai

Silakan enable snort-nic untuk nyalakan mode promiscuous mode pada interface monitoring
'systemctl start snort-nic'

Untuk monitoring silakan nyalakan service snort
'systemctl start snort'
"
