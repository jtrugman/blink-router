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
echo "---------------------------"
echo "Trying"
tc qdisc add dev eth0 root handle 1: prio priomap 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
tc qdisc add dev ifb0 root handle 1: prio priomap 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2

echo "---------------------------"
tc qdisc add dev eth0 root handle 10: htb default 30
tc qdisc add dev eth0 parent 1:1 handle 10: htb rate 2mbit
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dst 192.168.8.229/32 match ip dport 80 0xffff flowid 1:1
echo "Did it work?"
