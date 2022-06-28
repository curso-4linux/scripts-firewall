#!/bin/bash
IPT=$(which iptables)
REDE="192.168.200.0/24"

nat ()
{
$IPT -t nat -A POSTROUTING -s $REDE -o enp0s3 -j MASQUERADE
}
nat
