#!/bin/bash
mangle()
  {
    iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TOS --set-tos 0x10
    iptables -t mangle -A OUTPUT -p tcp --sport 80 -j TOS --set-tos 0x10
  }
mangle
