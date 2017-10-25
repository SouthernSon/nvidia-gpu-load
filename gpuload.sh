#!/bin/bash

gpulist=$(nvidia-settings -t -q gpus | grep -e '^\ *\[' | sed -e 's/^ *//')

while read LINE; do

	gpuid=$(echo "$LINE" | cut -d \  -f 2 | grep -E -o '\[.*\]')
	gpuname=$(echo "$LINE" | cut -d \  -f 3-)
	
	temp=( $(nvidia-settings -t -q "$gpuid"/GPUUtilization \
	-q "$gpuid"/GPUCoreTemp -q "$gpuid"/TotalDedicatedGPUMemory \
	-q "$gpuid"/UsedDedicatedGPUMemory | tr -d ',') )

	gpuusage=${temp[0]#*=}
	memoryusage=${temp[1]#*=}
	bandwidthusage=${temp[3]#*=}
	gputemp=${temp[4]}
	gputotalmem=${temp[5]}
	gpuusedmem=${temp[6]}
	
	echo "$gpuid $gpuname"
	echo -e "\tUsage:\t\t\t$gpuusage%"
	echo -e "\tCurrent temperature:\t$gputemp°C"
	echo -e "\tMemory usage:\t\t$gpuusedmem MB/$gputotalmem MB"
	echo -e "\tMemory bandwidth usage:\t$memoryusage%"
	echo -e "\tPCIe bandwidth usage:\t$bandwidthusage%"

done <<< "$gpulist"
