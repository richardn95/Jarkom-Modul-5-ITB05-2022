echo "nameserver 10.47.7.242" > /etc/resolv.conf

apt update
apt install apache2 -y
service apache2 start
echo "$HOSTNAME" > /var/www/html/index.html