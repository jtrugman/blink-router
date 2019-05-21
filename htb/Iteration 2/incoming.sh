tc qdisc del root dev br-lan
tc qdisc del root dev eth0
tc qdisc del root dev ifb0
echo "deleted everything"



modprobe ifb
ip link set dev ifb0 up
echo "1"
tc qdisc del dev br-lan ingress
echo "2"
tc qdisc add dev br-lan ingress
echo "3"
tc filter add dev br-lan parent ffff: \
   protocol ip u32 match u32 0 0 flowid 1:1 action mirred egress redirect dev ifb0
echo "4"
#tc qdisc add dev ifb0 root netem rate 5000kbit
#echo "5"

tc qdisc add dev ifb0 root handle 1: prio
tc qdisc add dev ifb0 parent 1:3 handle 30: \
netem delay 10000ms
echo "6"
tc filter add dev ifb0 protocol ip parent 1:0 prio 3 u32 \
     match ip dst 192.168.8.177/32 flowid 1:3
echo "7"
