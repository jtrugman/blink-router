tc qdisc del dev br-lan root


tc qdisc add dev br-lan root handle 1: htb default 12

tc class add dev br-lan parent 1: classid 1:1 htb rate 10000kbps ceil 1000kbps 
tc class add dev br-lan parent 1:1 classid 1:10 htb rate 3000kbps ceil 5000kbps
tc class add dev br-lan parent 1:1 classid 1:11 htb rate 1000kbps ceil 3000kbps


tc filter add dev br-lan protocol ip parent 1:0 prio 1 u32 \
   match ip src 192.168.8.194 match ip dport 80 0xffff flowid 1:10
tc filter add dev br-lan protocol ip parent 1:0 prio 1 u32 \
   match ip src 192.168.8.229 flowid 1:11
