#!/bin/sh                                                                                                                                                                    
# Variables                                                                               
IF_DSL=eth0                                                                               
TC=/usr/sbin/tc                                                                           
IPT=/usr/sbin/iptables                                                                    
IPTMOD="$IPT -t mangle -A POSTROUTING -o $IF_DSL"                                         
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
                                                                                          
$IPTMOD -s $IP_USER1 -j CLASSIFY --set-class 1:10                                         
echo Applied Limit to USER 1
$IPTMOD -s $IP_USER2 -j CLASSIFY --set-class 1:20                                         
echo Applied Limit to USER 2
#$IPTMOD -s $IP_USER3 -j CLASSIFY --set-class 1:30                                        
#$IPTMOD -s $IP_USER4 -j CLASSIFY --set-class 1:40                                                          
