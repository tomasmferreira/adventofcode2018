#!/bin/bash
freq=0
declare -A seen

while true; do
	while IFS= read -r op; do
		
		if [ -z $found_repeat ] && [ ${seen["$freq"]} ]; then
			found_repeat=1
			echo "Found repeated frequency $freq"
			exit 0
		else
			seen["$freq"]=1
		fi

		let freq=freq$op

	done < $1


	if [ -z $day1 ]; then
		echo final freq: $freq
		day1="done"
	fi
done
if [ -z $found_repeat ] && [ ${seen["$freq"]} ]; then
	echo "Found repeated frequency $freq"
fi

