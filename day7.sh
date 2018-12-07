#!/bin/bash
cat $1 > /tmp/after.txt
res=""
out=0

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

function part1 {
	input=$1
	while [ ! -z "$(cat /tmp/after.txt)" ] && [ $out -eq 0 ]; do
		out=1
		for step in {A..Z}; do
			if [ -z "$(echo $res | grep $step)" ]; then
				if [ -z "$(cat /tmp/after.txt | grep "$step can begin")" ]; then
					res=$res$step
					perl -pe "s/Step $step must.*\n//g" -i /tmp/after.txt
					out=0
					break
				fi
			fi
		done
	done

	#find last letter(s)
	for step in {A..Z}; do
		if [ -z "$(cat $input | grep "Step $step must")" ]; then
			res=$res$step
			break
		fi
	done

	echo $res
}

function part2 {
	input=$1
	nWorkers=$2
	res=""

	#initialize workers
	for((i=0;i<nWorkers;i++)); do
		worker[$i]="0"
	done

	#find last letter(s)
	i=0
	for step in {A..Z}; do
		if [ ! -z "$(cat /tmp/after.txt | grep " $step ")" ] && [ -z "$(cat $1 | grep "Step $step must")" ]; then
			last[$i]=$step
			let i++
		fi
	done
	echo "last(s): ${last[@]}"
	echo

	time=0
	while [ ! -z "$(cat /tmp/after.txt)" ] || [ ! -z "$(echo ${worker[@]} | tr ' ' '\n' | grep -v 0)" ]; do
		#check for work
		if [ ! -z "$(echo ${worker[@]} | grep 0)" ]; then
			for step in {A..Z}; do
				if [ ! -z "$(cat /tmp/after.txt | grep " $step ")" ] && [ -z "$(echo $res | grep $step)" ] && [ -z "$(echo ${workingOn[@]} | grep $step)"]; then
					if [ -z "$(cat /tmp/after.txt | grep "$step can begin")" ]; then
						for((i=0;i<nWorkers;i++)); do
							if [ ${worker[$i]} -eq 0 ]; then
								worker[$i]=$(($(ord $step)-4))
								workingOn[$i]=$step
								res=$res$step
								break
							fi
						done
					fi
				fi
			done
		fi 


		for((i=0;i<nWorkers;i++)); do
			if [ ${worker[$i]} -gt 0 ]; then
				worker[$i]="$((${worker[$i]}-1))"
				if [ ${worker[$i]} -eq 0 ]; then
					perl -pe "s/Step ${workingOn[$i]} must.*\n//g" -i /tmp/after.txt
				fi
			fi
		done


		#check if any of the last are ready
		for step in ${last[@]}; do
			if [ -z "$(cat /tmp/after.txt | grep " $step ")" ] && [ -z "$(echo $res | grep $step)" ] && [ -z "$(echo ${workingOn[@]} | grep $step)"]; then
				for((i=0;i<nWorkers;i++)); do
					if [ ${worker[$i]} -eq 0 ]; then
						worker[$i]=$(($(ord $step)-4))
						workingOn[$i]=$step
						res=$res$step
						break
					fi
				done
			fi
		done

		let time++
	done

	for((i=0;i<nWorkers;i++)); do
		time=$(($time+${worker[$i]}))
	done

	echo Took $time to complete
}


#part1 $1
part2 $1 5

