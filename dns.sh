#!/bin/bash
dns()
	{
		iptables -A INPUT -p udp -s 0/0 --sport 53 -d 10.0.2.15/32 --dport 1024:65535 -j ACCEPT
		iptables -A INPUT -p icmp --icmp-type 3 -s 0/0 -d 10.0.2.15/32 -j ACCEPT
		iptables -A OUTPUT -p udp -s 10.0.2.15/32 --sport 1024:65535 -d 0/0 --dport 53 -j ACCEPT
	}
dns
