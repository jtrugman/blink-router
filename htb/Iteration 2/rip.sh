
tc qdisc add dev br-lan root handle 1: prio #Applies everything to handle 1 queue
echo "1"
tc qdisc add dev br-lan parent 1:3 handle 30: \
netem rate 5000kbit  # Applies policing to class 1:3 - To add anothher policing rate, change the parent 1:3 to 1:X
echo "2"

 tc filter add dev br-lan protocol ip parent 1:0 prio 3 u32 \
     match ip dst 192.168.8.237/32 flowid 1:3 # replace IP address and flow id with corresponding from above
echo "4"
