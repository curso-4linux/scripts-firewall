#!/bin/bash
ssh()
	{
		iptables -A INPUT -p tcp -s 0/0 --sport 1024:65535 -d 192.168.200.2 --dport 22 -j ACCEPT
		iptables -A OUTPUT -p tcp -s 192.168.200.2 --sport 22 -d 0/0 --dport 1024:65535 -j ACCEPT
	}
ssh
