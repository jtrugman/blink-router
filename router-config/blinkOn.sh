#!/bin/sh

# Editing Network Config File
NET_FILE="/etc/config/network"

/bin/cat << EOM > $NET_FILE

config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'fd0b:6f78:e574::/48'

config interface 'lan'
        option type 'bridge'
        option ifname 'eth1'
        option proto 'static'
        option netmask '255.255.255.0'
        option ip6assign '60'
        option hostname 'GL-AR300M-6cf'
        option ipaddr '192.168.8.1'

config interface 'wan'
        option ifname 'eth0'
        option proto 'dhcp'
        option hostname 'GL-AR300M-6cf'

config interface 'wan6'
        option ifname 'eth0'
        option proto 'dhcpv6'

config interface 'blink'
       option proto 'static'
       option ipaddr '10.0.0.1'
       option netmask '255.255.255.0'


EOM


# Editing Wireless Config File
WIRELESS_FILE="/etc/config/wireless"

/bin/cat << EOM > $WIRELESS_FILE

config wifi-device 'radio0'
        option type 'mac80211'
        option path 'platform/qca953x_wmac'
        option hwmode '11ng'
        option channel '6'
        option noscan '1'
        option txpower '20'
        option htmode 'HT40-'

config wifi-iface 'default_radio0'
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option encryption 'psk-mixed'
        option wds '1'
        option ifname 'wlan0'
        option ssid 'blinkNode3'
        option key 'enter1234'

config wifi-iface
       option device     'radio0'
       option mode       'ap'
       option network    'blink'
       option ssid       'blink'
       option encryption 'none'

EOM

# Editing DHCP Config File

DHCP_FILE="/etc/config/dhcp"

/bin/cat << EOM > $DHCP_FILE

config dnsmasq
        option domainneeded '1'
        option boguspriv '1'
        option filterwin2k '0'
        option localise_queries '1'
        option rebind_protection '1'
        option rebind_localhost '1'
        option local '/lan/'
        option domain 'lan'
        option expandhosts '1'
        option nonegcache '0'
        option authoritative '1'
        option readethers '1'
        option leasefile '/tmp/dhcp.leases'
        option resolvfile '/tmp/resolv.conf.auto'
        option localservice '1'

config dhcp 'lan'
        option interface 'lan'
        option start '100'
        option limit '150'
        option leasetime '12h'
        option force '1'
        option dhcpv6 'server'
        option ra 'server'

config dhcp 'wan'
        option interface 'wan'
        option ignore '1'

config odhcpd 'odhcpd'
        option maindhcp '0'
        option leasefile '/tmp/hosts/odhcpd'
        option leasetrigger '/usr/sbin/odhcpd-update'

config domain 'localhost'
        option name 'console.gl-inet.com'
        option ip '192.168.8.1'

config dhcp 'blink'
        option interface 'blink'
        option start '50'
        option limit '200'
        option leasetime '1h'

EOM

# Editing Firewall Config File

FIREWALL_FILE="/etc/config/firewall"
/bin/cat << EOM > $FIREWALL_FILE

config defaults
	option syn_flood '1'
	option input 'ACCEPT'
	option output 'ACCEPT'
	option forward 'REJECT'

config zone
	option name 'lan'
	list network 'lan'
	option input 'ACCEPT'
	option output 'ACCEPT'
	option forward 'ACCEPT'

config zone
	option name 'wan'
	list network 'wan'
	list network 'wan6'
	option input 'REJECT'
	option output 'ACCEPT'
	option forward 'REJECT'
	option masq '1'
	option mtu_fix '1'

config forwarding
	option src 'lan'
	option dest 'wan'

config rule
	option name 'Allow-DHCP-Renew'
	option src 'wan'
	option proto 'udp'
	option dest_port '68'
	option target 'ACCEPT'
	option family 'ipv4'

config rule
	option name 'Allow-Ping'
	option src 'wan'
	option proto 'icmp'
	option icmp_type 'echo-request'
	option family 'ipv4'
	option target 'ACCEPT'

config rule
	option name 'Allow-IGMP'
	option src 'wan'
	option proto 'igmp'
	option family 'ipv4'
	option target 'ACCEPT'

config rule
	option name 'Allow-DHCPv6'
	option src 'wan'
	option proto 'udp'
	option src_ip 'fc00::/6'
	option dest_ip 'fc00::/6'
	option dest_port '546'
	option family 'ipv6'
	option target 'ACCEPT'

config rule
	option name 'Allow-MLD'
	option src 'wan'
	option proto 'icmp'
	option src_ip 'fe80::/10'
	list icmp_type '130/0'
	list icmp_type '131/0'
	list icmp_type '132/0'
	list icmp_type '143/0'
	option family 'ipv6'
	option target 'ACCEPT'

config rule
	option name 'Allow-ICMPv6-Input'
	option src 'wan'
	option proto 'icmp'
	list icmp_type 'echo-request'
	list icmp_type 'echo-reply'
	list icmp_type 'destination-unreachable'
	list icmp_type 'packet-too-big'
	list icmp_type 'time-exceeded'
	list icmp_type 'bad-header'
	list icmp_type 'unknown-header-type'
	list icmp_type 'router-solicitation'
	list icmp_type 'neighbour-solicitation'
	list icmp_type 'router-advertisement'
	list icmp_type 'neighbour-advertisement'
	option limit '1000/sec'
	option family 'ipv6'
	option target 'ACCEPT'

config rule
	option name 'Allow-ICMPv6-Forward'
	option src 'wan'
	option dest '*'
	option proto 'icmp'
	list icmp_type 'echo-request'
	list icmp_type 'echo-reply'
	list icmp_type 'destination-unreachable'
	list icmp_type 'packet-too-big'
	list icmp_type 'time-exceeded'
	list icmp_type 'bad-header'
	list icmp_type 'unknown-header-type'
	option limit '1000/sec'
	option family 'ipv6'
	option target 'ACCEPT'

config rule
	option name 'Allow-IPSec-ESP'
	option src 'wan'
	option dest 'lan'
	option proto 'esp'
	option target 'ACCEPT'

config rule
	option name 'Allow-ISAKMP'
	option src 'wan'
	option dest 'lan'
	option dest_port '500'
	option proto 'udp'
	option target 'ACCEPT'

config include
	option path '/etc/firewall.user'

config include 'miniupnpd'
	option type 'script'
	option path '/usr/share/miniupnpd/firewall.include'
	option family 'any'
	option reload '1'

config include 'shadowsocks'
	option type 'script'
	option path '/var/etc/shadowsocks.include'
	option reload '1'

config rule 'glservice_rule'
	option name 'glservice'
	option dest_port '83'
	option proto 'tcp udp'
	option src 'wan'
	option target 'ACCEPT'
	option enabled '0'

config zone
    option name 'blink'
    option network 'blink'
    option input 'REJECT'
    option forward 'REJECT'
    option output 'ACCEPT'
  
  
  config forwarding
    option src 'blink'
    option dest 'wan'
    
 config rule
    option name 'Allow DNS Queries'
    option src 'blink'
    option dest_port '53'
    option proto 'tcp udp'
    option target 'ACCEPT'
  
 
  config rule
    option name 'Allow DHCP request'
    option src 'blink'
    option src_port '67-68'
    option dest_port '67-68'
    option proto 'udp'
    option target 'ACCEPT'

EOM

# Restart init files
/etc/init.d/network restart
/etc/init.d/firewall restart
/etc/init.d/dnsmasq restart

