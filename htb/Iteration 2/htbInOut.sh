

modprobe ifb numifbs=1
ip link set dev ifb0 up
echo "ifb0"

tc qdisc del root dev ifb0
echo "Delete ifb0 -- May Return No Such File or Directory (Its OK if it does)"
tc qdisc del root dev br-lan
echo "Deleted Eth Devices"


tc qdisc del dev br-lan handle ffff: ingress
echo "delete ingress"
tc qdisc add dev br-lan handle ffff: ingress
echo "1"
tc filter add dev br-lan parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0
echo "2"
tc qdisc add dev br-lan root handle 1: htb default 30
echo "3"
tc class add dev br-lan parent 1: classid 1:1 htb rate 25mbit
echo "4"
tc class add dev br-lan parent 1:1 classid 1:10 htb rate 5mbit
tc class add dev br-lan parent 1:1 classid 1:11 htb rate 20mbit

echo "Done with Egress"



echo "Starting Ingress"
tc qdisc add dev ifb0 root handle 1: htb default 30
echo "Ingress 1"
tc class add dev ifb0 parent 1: classid 1:1 htb rate 25mbit
echo "Ingress 2"
tc class add dev ifb0 parent 1:1 classid 1:10 htb rate 5mbit
tc class add dev ifb0 parent 1:1 classid 1:11 htb rate 20mbit

echo "Ingress 3"
echo "Done with Ingress"






tc filter add dev br-lan parent 1: protocol ip prio 2 u32 match ip src 192.168.8.229/32 match ip sport 80 0xffff flowid 1:11
tc filter add dev ifb0 parent 1: protocol ip prio 2 u32 match ip src 192.168.8.229/32 match ip sport 80 0xffff flowid 1:11


  echo "Filters Applied"
