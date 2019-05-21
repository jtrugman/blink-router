#!/bin/bash


# Interface connect to out lan
int1="eth0"
# Interface virtual for incomming traffic
tin1="ifb0"
# Lan address (without netmask part)
lan1="192.168.8."

Lower= "3000kbit"
Bandwidth = "5000kbit"

# It's necessary load this module in the kernel for do it
modprobe ifb numifbs=1
ip link set dev $tin1 up

echo "IFB UP"

## Limit outcomming traffic (to internet)
# Clean interface
tc qdisc del root dev $int1
echo "outgoing interface cleared"

# Add classes per ip
tc qdisc add dev $int1 root handle 1: htb default 20
echo "out going interface class"

	tc class add dev $int1 parent 1: classid 1:1 htb rate 3000kbit
		for i in $(seq 1 255); do # For each ip address set rate = 80kbit & ceiling to 20480kbit
			tc class add dev $int1 parent 1:1 classid 1:1$i htb rate 3000kbit ceil 5000kbit
		done
		echo "Added IP"

# Match ip and put it into the respective class
for i in $(seq 1 255); do
	tc filter add dev $int1 protocol ip parent 1: prio 1 u32 match ip dst $lan1$i/32 flowid 1:1$i
done
echo "Applied class to IP"






## Limit incomming traffic ( to localhost)
# Clean interface
tc qdisc del dev $int1 handle ffff: ingress
tc qdisc del root dev $tin1
tc qdisc add dev $int1 handle ffff: ingress
echo "Refreshed Incoming Queue"
# Redirecto ingress eth0 to egress ifb0
tc filter add dev $int1 parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev $tin1
echo "Added Incoming Filter"

# Add classes per ip
tc qdisc add dev $tin1 root handle 2: htb default 20
	tc class add dev $tin1 parent 2: classid 2:1 htb rate 3000kbit
		for i in $(seq 1 255); do
			tc class add dev $tin1 parent 2:1 classid 2:1$i htb rate 3000kbit ceil 5000kbit
		done
	echo "Added HTB to incoming"

# Match ip and put it into the respective class
for i in $(seq 1 255); do
	tc filter add dev $tin1 protocol ip parent 2: prio 1 u32 match ip src $lan1$i/32 flowid 2:1$i
done
echo "Applied class"

echo "complete"
