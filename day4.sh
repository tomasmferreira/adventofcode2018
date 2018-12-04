#!/bin/bash
declare -A schedules
declare -A guards
guard=""
sleeping=0
slept=0
woke=0

#prep structs
for line in $(cat $1 | tr ' ' '_' | sort); do
	line="$(echo $line | tr '_' ' ')"

	if [[ $line = *Guard* ]]; then
		guard="$(echo $line | sed 's/.*\#\([0-9]*\).*/\1/')"
	elif [[ $line = *falls* ]]; then
		hour="$(echo $line | grep -Po '..(?=:..)')"
		if [ $hour -eq 0 ]; then
			slept=$(echo $line | grep -Po '(?<=..:)..')
		else
			slept=0
		fi
	elif [[ $line = *wakes* ]]; then
		woke=$(echo $line | grep -Po '(?<=..:)..')
		sleeping=$((${woke#0}-${slept#0}))

		for ((i=${slept#0}; i<${woke#0}; i++)); do
			if [[ ! -z ${schedules[$guard$i]} ]]; then
				schedules[$guard$i]=$((${schedules[$guard$i]}+1))
			else
				schedules[$guard$i]=1
			fi
		done

		if [ ! -z ${guards[$guard]} ]; then
			guards[$guard]=$((${guards[$guard]}+$sleeping))
		else
			guards[$guard]=$sleeping
		fi
	fi
done

#####################################################################
#
#									PART 1
#
#####################################################################
#find most sleeper
maxSlept=0
sleepy=""
for guard in "${!guards[@]}"; do
	if [ ${guards[$guard]} -gt $maxSlept ]; then
		maxSlept=${guards[$guard]}
		sleepy=$guard
	fi
done
#find best hour
best=-1
schedules[$sleepy$best]=-1
for ((i=0;i<60;i++)); do
	if [ ! -z ${schedules[$sleepy$i]} ] && [ ${schedules[$sleepy$i]} -gt "${schedules[$sleepy$best]}" ]; then
		best=$i
	fi
done

echo Guard \#$sleepy was caught sleeping at 00:$best, in ${schedules[$sleepy$best]} of the days
echo Part1: $(($sleepy*$best))


#####################################################################
#
#									PART 2
#
#####################################################################
mostSlept=0
for guard in "${!guards[@]}"; do
	for ((i=0;i<60;i++)); do
		if [ ! -z ${schedules[$guard$i]} ] && [ ${schedules[$guard$i]} -gt $mostSlept ]; then
			sleepy=$guard
			mostSlept=${schedules[$guard$i]}
			best=$i
		fi
	done
done

echo Guard \#$sleepy was caught sleeping $mostSlept times at 00:$best
echo Part2: $(($sleepy*$best))