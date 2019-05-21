#!/bin/sh

modprobe sch_netem
echo "What mbit do you want to limit the bandwidth too?"
read num

tc qdisc add dev br-lan root netem rate $num mbit

