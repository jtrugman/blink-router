modprobe ifb numifbs=1
ip link set dev ifb0 up
echo "ifb0"

tc qdisc del root dev ifb0
echo "Delete ifb0 -- May Return No Such File or Directory (Its OK if it does)"
tc qdisc del root dev eth0
echo "Deleted Eth Devices"


tc qdisc del dev eth0 handle ffff: ingress
echo "delete ingress"
tc qdisc add dev eth0 handle ffff: ingress
echo "1"
tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0
echo "2"
tc qdisc add dev eth0 root handle 1: htb default 10
echo "3"
tc class add dev eth0 parent 1: classid 1:1 htb rate 1mbit
echo "4"
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 1mbit
echo "Done with Egress"



echo "Starting Ingress"
tc qdisc add dev ifb0 root handle 1: htb default 10
echo "Ingress 1"
tc class add dev ifb0 parent 1: classid 1:1 htb rate 1mbit
echo "Ingress 2"
tc class add dev ifb0 parent 1:1 classid 1:10 htb rate 1mbit
echo "Ingress 3"
echo "Done with Ingress"
