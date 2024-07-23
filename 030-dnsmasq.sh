#!/bin/bash

sudo apt install dnsmasq -y

sudo sed -i 's/#port=5353/port=5353/' /etc/dnsmasq.conf
sudo sed -i 's/#conf-dir=\/etc\/dnsmasq.d\/,\*\.conf/conf-dir=\/etc\/dnsmasq.d\/,*.conf/' /etc/dnsmasq.conf

echo "address=/localhost/127.0.0.1
address=/wp/127.0.0.1
" | sudo tee /etc/dnsmasq.d/develop.conf

sudo sed -i 's/#DNS=/DNS=127.0.0.1:5353/' /etc/systemd/resolved.conf
sudo sed -i 's/#FallbackDNS=/FallbackDNS=8.8.8.8#dns.google 8.8.4.4#dns.google/' /etc/systemd/resolved.conf

sudo service dnsmasq restart
sudo resolvectl flush-caches
sudo service systemd-resolved restart
sudo resolvectl status
