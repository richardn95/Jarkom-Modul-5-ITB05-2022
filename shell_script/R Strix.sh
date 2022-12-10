# Ke Ostania
route add -net 10.47.7.224 netmask 255.255.255.248 gw 10.47.7.254 #A1
route add -net 10.47.4.0 netmask 255.255.254.0 gw 10.47.7.254 #A2
route add -net 10.47.6.0 netmask 255.255.255.0 gw 10.47.7.254 #A3
route add -net 10.47.7.252 netmask 255.255.255.252 gw 10.47.7.254 #A4

#Ke Westalis
route add -net 10.47.7.248 netmask 255.255.255.252 gw 10.47.7.250 #A5
route add -net 10.47.0.0 netmask 255.255.252.0 gw 10.47.7.250 #A6
route add -net 10.47.7.128 netmask 255.255.255.192 gw 10.47.7.250 #A7
route add -net 10.47.7.240 netmask 255.255.255.248 gw 10.47.7.250 #A8

echo "nameserver 192.168.122.1" > /etc/resolv.conf

IPETH0="$(ip -br a | grep eth0 | awk '{print $NF}' | cut -d'/' -f1)"
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source "$IPETH0" -s 10.47.0.0/21

iptables -A FORWARD -d 10.47.7.243 -i eth0 -p tcp -j LOG --log-level 5
iptables -A FORWARD -d 10.47.7.243 -i eth0 -p udp -j LOG --log-level 5

iptables -A FORWARD -d 10.47.7.243 -i eth0 -p tcp -j DROP
iptables -A FORWARD -d 10.47.7.243 -i eth0 -p udp -j DROP

service rsyslog restart