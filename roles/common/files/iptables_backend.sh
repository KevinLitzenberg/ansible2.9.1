#!/bin/bash

# iptables_frontend.sh: Completed on Fri Dec 20 18:49:19 2019
# iptables_backend.sh: Completed on Sat Dec 21 01:53:35 2019

# setup basic chains and allow all or we might get locked out while the rules are running...
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# clear rules
iptables -F

# allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# allow local prod
iptables -A INPUT -s 172.30.0.0/24 -j ACCEPT

# allow local aws
iptables -A INPUT -s 172.31.32.0/20 -j ACCEPT

# allow  Base Forwarding
#iptables -A FORWARD -i eth0 -j ACCEPT
#iptables -A FORWARD -o eth0 -j ACCEPT

# allow HTTP inbound and replies for testing backends
#iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# prevent DoS Attack
#iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

# allow inbound backdoor admin
iptables -A INPUT -p tcp -s 162.245.23.186/32 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -d 162.245.23.186/32 --dport 22 -m conntrack --ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s 13.56.75.111/32 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -d 13.56.75.111/32 --dport 22 -m conntrack --ESTABLISHED -j ACCEPT

# allow SSH inbound and replies for testing on backends
#iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# allow SSH outbound for testing on backends
#iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A INPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# allow outbound DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT

# allow NTP
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p udp --sport 123 -j ACCEPT

# drop everything else
iptables -P INPUT DROP
iptables -P FORWARD DROP
#iptables -P OUTPUT DROP

# save config
/sbin/iptables-save
