* Add to /etc/iproute2/rt_tables
* `ip route add table $GW default via $GW_IP dev $GW_DEV metric 100`
* `ip rule add prio 100 from all fwmark $MARK lookup $GW`
* `iptables -A PREROUTING -t mangle -s $SOURCE_IP -j MARK --set-mark 0x$MARK`
