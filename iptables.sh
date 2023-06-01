#########################
SOLVED BY JEAN STAFFE
#########################
#enp0s3 is LAN
#enp0s8 is WAN
#enp0s9 is DMZ
#!/bin/bash
#FLUSH ALL
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
iptables -t nat -F PREROUTING
iptables -t nat -F POSTROUTING
######################
#filter#
######################
INPUT RULES
#Règles INPUT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -p tcp -s 10.1.41.4 --dport 22 -j ACCEPT
iptables -A INPUT -j REJECT

FORWARD RULES
#Règles FORWARD
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -p icmp -d 172.16.0.0/16 -j ACCEPT
iptables -A FORWARD -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.1.2 --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp -i enp0s8 -d 172.16.0.2 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -s 192.168.1.2 -d 172.16.0.2 -m multiport --dports 80,21,20,990 -j ACCEPT
iptables -A FORWARD -p tcp -i enp0s8 -d 172.16.0.2 --dport 22 -j ACCEPT
iptables -A FORWARD -j REJECT

OUTPUT RULES
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A OUTPUT -j REJECT

######################
#nat#
######################
###Dnat###
#Règles de dnat
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to 172.16.0.2
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 61337 -j DNAT --to 172.16.0.2:22
###Snat###
#Règles de snat

iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o enp0s8 -j SNAT --to-source 10.1.41.25 (ip vm)