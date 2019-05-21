sed --in-place '28,32d' network
sed --in-place '21,26d' wireless
sed --in-place '146,172d' firewall
sed --in-place '41,45d' dhcp

/etc/init.d/network restart
/etc/init.d/firewall restart
/etc/init.d/dnsmasq restart

