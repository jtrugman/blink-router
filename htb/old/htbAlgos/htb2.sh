#!/bin/sh                                                                                                                                                                    
# Variables                                                                               
IF_DSL=br-lan                                                                               
TC=/usr/sbin/tc                                                                           
IPT=/usr/sbin/iptables                                                                                                             
IP_USER1=192.168.8.194                                                                    
IP_USER2=192.168.8.139                                                                    
#IP_USER3=10.0.0.3                                                                        
#IP_USER4=10.0.0.4                                                                        
                                                                                          
insmod sch_htb                                                                            
                                                                                          
$TC qdisc del dev $IF_DSL root                                                 
echo Deleted Previous qdisc          
                                                                                          
                                                                                          
$TC qdisc add dev $IF_DSL root       handle 1:    htb default 40                          
echo Added Root
$TC class add dev $IF_DSL parent 1:  classid 1:1  htb rate 10000kbit                      
echo Added Base Limit
$TC class add dev $IF_DSL parent 1:1 classid 1:10 htb rate 5000kbit      
echo Added USER 1
$TC class add dev $IF_DSL parent 1:1 classid 1:20 htb rate 2500kbit      
echo Added USER 2
#$TC class add dev $IF_DSL parent 1:1 classid 1:30 htb rate 350kbit #-- 35% to user3      
#$TC class add dev $IF_DSL parent 1:1 classid 1:40 htb rate 150kbit #-- 15% to user4      
                                                                                          
$TC filter add dev $IF_DSL parent 1:10 protocol ip prio 1 u32 \ 
  match ip dst $IP_USER1/32 flowid 1:1 
echo added user 1 to filter

$TC filter add dev $IF_DSL parent 1:20 protocol ip prio 1 u32 \
  match ip src $IP_USER2/32 flowid 1:1  
echo added user 2 to filter

$TC filter add dev $IF_DSL protocol ip parent 1: prio 2      \
  flowid 1:                                                      
