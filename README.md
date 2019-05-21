# blink-router
Code and Scripts from the Blink Wifi Router

This repo contains code/scripts for
- Traffic Steering (Can steer traffic on both the up-link and down-link)
- Traffic Policing 
- Traffic Shaping using the HTB (Hierarchical Token Bucket) Algorithm
- Wifi Mesh (Wifi mesh configs using the BATMAN wifi mesh)
- Traffic Monitoring & Collection (Script to run tcpdump and store pcap or pcapng files on portable hardrive or NAS attached to router)

Before running programs make sure to update router (opkg update)
And to install required programs for example to install tcpdump (opkg install tcpdump)
