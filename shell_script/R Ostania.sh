route add -net 0.0.0.0 netmask 0.0.0.0 gw 10.47.7.253

echo "nameserver 10.47.7.242" > /etc/resolv.conf

apt update
apt install isc-dhcp-relay -y
echo '
SERVERS="10.47.7.243"
INTERFACES="eth1 eth2 eth3 eth0"
OPTIONS=""
' > /etc/default/isc-dhcp-relay
service isc-dhcp-relay restart

iptables -A FORWARD -d 10.47.7.243 -m time --weekdays Sat,Sun -j LOG --log-level 5
iptables -A FORWARD -d 10.47.7.243 -m time --timestart 00:00 --timestop 06:59 --weekdays Mon,Tue,Wed,Thu,Fri -j LOG --log-level 5
iptables -A FORWARD -d 10.47.7.243 -m time --timestart 16:01 --timestop 23:59 --weekdays Mon,Tue,Wed,Thu,Fri -j LOG --log-level 5

iptables -A FORWARD -d 10.47.7.226 -m time --weekdays Sat,Sun -j LOG --log-level 5
iptables -A FORWARD -d 10.47.7.226 -m time --timestart 00:00 --timestop 06:59 --weekdays Mon,Tue,Wed,Thu,Fri -j LOG --log-level 5
iptables -A FORWARD -d 10.47.7.226 -m time --timestart 16:01 --timestop 23:59 --weekdays Mon,Tue,Wed,Thu,Fri -j LOG --log-level 5


iptables -A FORWARD -d 10.47.7.243 -m time --weekdays Sat,Sun -j REJECT
iptables -A FORWARD -d 10.47.7.243 -m time --timestart 00:00 --timestop 06:59 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
iptables -A FORWARD -d 10.47.7.243 -m time --timestart 16:01 --timestop 23:59 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT

iptables -A FORWARD -d 10.47.7.226 -m time --weekdays Sat,Sun -j REJECT
iptables -A FORWARD -d 10.47.7.226 -m time --timestart 00:00 --timestop 06:59 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
iptables -A FORWARD -d 10.47.7.226 -m time --timestart 16:01 --timestop 23:59 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT

iptables -A PREROUTING -t nat -p tcp -d 10.47.7.226 --dport 80 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.47.7.226:80
iptables -A PREROUTING -t nat -p tcp -d 10.47.7.226 --dport 80 -j DNAT --to-destination 10.47.7.227:80

iptables -A PREROUTING -t nat -p tcp -d 10.47.7.227 --dport 443 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.47.7.227:443
iptables -A PREROUTING -t nat -p tcp -d 10.47.7.227 --dport 443 -j DNAT --to-destination 10.47.7.226:443

service rsyslog restart