#!/bin/bash
IPT=$(which iptables)

### Interfaces ADSLs
ADSL1 = " eth1 "
ADSL2 = " eth3 "

### Gateways dos ADSLs
GW1="10.0.3.2"
GW2="10.0.5.2"

### Limpa tabelas de roteamento no cache
ip route flush cache

### Definição da tabelas dinâmicas a partir das marcas
ip rule add fwmark 10 table link1 prio 20
ip rule add fwmark 20 table link2 prio 20

### Definição de rotas para pacotes marcados
ip route add default via $GW1 table link1
ip route add default via $GW2 table link2

### Adicione rota principal na tabela link1
ip route show table main | grep -Ev ’^default’ | while read ROUTE ;
do ip route add table link1 $ROUTE ; done

### Escreve o fwmark da tabela a partir do estado de pacote
$IPT -t mangle -A PREROUTING -j CONNMARK -- restore - mark

### Aceita apenas pacotes que não possuam a marca 0
$IPT -t mangle -A PREROUTING -m mark ! -- mark 0 -j ACCEPT

### Escreve o fwmark 10 ( link1 ) em um pacote IP
$IPT -t mangle -A PREROUTING -j MARK -- set - mark 10

### Seleciona 50% pacotes aleatórios para o a fwmark 20 ( link2 )
$IPT -t mangle -A PREROUTING -m statistic --mode random --probability 0.5 -j MARK --set- mark 20

### Escreve o fwmark do pacote a partir do estado da tabela
$IPT -t mangle -A PREROUTING -j CONNMARK -- save - mark

### Mascarara saídas para os dois ADSLs
$IPT -t nat -A POSTROUTING -o $ADSL1 -j MASQUERADE
$IPT -t nat -A POSTROUTING -o $ADSL2 -j MASQUERADE                                                   
