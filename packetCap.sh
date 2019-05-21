#!/bin/bash

echo What interface do you want to monitor?

read dev

echo Where do you want to save the file?

read writeFile

tcpdump -i $dev -w $writeFile

