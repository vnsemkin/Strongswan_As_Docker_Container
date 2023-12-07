#!/bin/bash

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.ip_no_pmtu_disc = 1" >> /etc/sysctl.conf
sysctl -p

# Add iptables rules
iptables -A FORWARD --match policy --pol ipsec --dir in -s 10.10.10.0/24 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -m policy --pol ipsec --dir out -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE

# Add ufw routes
ufw allow 500,4500/udp
ufw route allow in on eth0 out on eth0 from 10.10.10.0/24
ufw route allow out on eth0 in on eth0 to 10.10.10.0/24

# Disable and enable ufw
ufw disable
ufw enable

# Start StrongSwan
/usr/sbin/ipsec start --nofork
