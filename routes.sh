#!/bin/bash
gateway_ip=`/sbin/route | awk '/^default/{print $2}'`
gateway_device=`/sbin/route | awk '/^default/{print $NF}'`
dns_servers=`awk '/^nameserver/{print $2}' /etc/resolv.conf`
for denys_ip in vmi1527139.contaboserver.net 91.215.61.157 simfero.kscrimea.org simfero.tezcrimea.org kp.climatworld.com $gateway_ip $dns_servers; do
	/sbin/route add -host $denys_ip gw $gateway_ip dev $gateway_device
done
