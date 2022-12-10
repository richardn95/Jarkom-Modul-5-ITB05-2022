echo "nameserver 10.47.7.242" > /etc/resolv.conf

apt-get update
apt-get install isc-dhcp-server -y
echo '
INTERFACES="eth0"
' > /etc/default/isc-dhcp-server

# DHCP A2 A3 A6 A7
# STAT A1 A4 A5 A8
echo '
subnet 10.47.7.224 netmask 255.255.255.248 {}
subnet 10.47.7.252 netmask 255.255.255.252 {}
subnet 10.47.7.248 netmask 255.255.255.252 {}
subnet 10.47.7.240 netmask 255.255.255.248 {}

subnet '10.47.4.0' netmask '255.255.254.0' {
    range '10.47.4.2' '10.47.5.254';
    option routers '10.47.4.1';
    option broadcast-address '10.47.5.255';
    option domain-name-servers '10.47.7.242';
    default-lease-time '720';
    max-lease-time '7200';
}
subnet '10.47.6.0' netmask '255.255.255.0' {
    range '10.47.6.2' '10.47.6.254';
    option routers '10.47.6.1';
    option broadcast-address '10.47.6.255';
    option domain-name-servers '10.47.7.242';
    default-lease-time '720';
    max-lease-time '7200';
}
subnet '10.47.0.0' netmask '255.255.252.0' {
    range '10.47.0.2' '10.47.3.254';
    option routers '10.47.0.1';
    option broadcast-address '10.47.3.255';
    option domain-name-servers '10.47.7.242';
    default-lease-time '720';
    max-lease-time '7200';
}
subnet '10.47.7.128' netmask '255.255.255.192' {
    range '10.47.7.130' '10.47.7.190';
    option routers '10.47.7.129';
    option broadcast-address '10.47.7.191';
    option domain-name-servers '10.47.7.242';
    default-lease-time '720';
    max-lease-time '7200';
}
' > /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart

iptables -A INPUT -p icmp -m connlimit --connlimit-above 2 --connlimit-mask 0 -j LOG --log-level 5

iptables -A INPUT -p icmp -m connlimit --connlimit-above 2 --connlimit-mask 0 -j DROP

service rsyslog restart