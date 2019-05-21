tc qdisc add dev eth0 root handle 1: prio
tc qdisc add dev eth0 parent 1:3 handle 30: \
tc qdisc add dev eth0 parent 30:1 handle 31: \
netem  delay 10000ms 10000ms distribution normal
tc filter add dev eth0 protocol ip parent 1:0 prio 3 u32 \
     match ip dst 192.168.8.177/32 flowid 1:3
