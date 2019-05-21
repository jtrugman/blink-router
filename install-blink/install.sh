#!/bin/sh

# Script to Install Blink Router Configuration & Tools


# Login info
password="enter1234"
user="root"
addr="192.168.8.1"

# scp install folder to router
sshpass -p "$password" scp -r ~/Desktop/install-blink $user@$addr:~/


# Move out of install folder into home directory
sshpass -p "$password" ssh $user@$addr 
mv blinkOff.sh ../blinkOff.sh
mv blinkOn.sh ../blinkOn.sh 
mv packetCap.sh ../packetCap.sh

rm /install-blink/install.sh
rmdir install-blink
