sed --in-place '28,32d' /etc/config/network
sed --in-place '21,26d' /etc/config/wireless
sed --in-place '146,172d' /etc/config/firewall
sed --in-place '41,45d' /etc/config/dhcp

/etc/init.d/network restart
/etc/init.d/firewall restart
/etc/init.d/dnsmasq restart

