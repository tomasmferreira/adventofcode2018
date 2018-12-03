#!/bin/bash

function part1 {
	declare -A seenPairs
	declare -A seenTriplets

	pairs=0
	triplets=0

	while IFS= read -r line; do
		declare -A seenLine
		
		for char in $(echo $line | sed 's/\(.\)/\1 /g'); do
			if [ -z ${seenLine[$char]} ]; then
				seenLine[$char]=1
			else 
				seenLine[$char]=$((${seenLine[$char]}+1))
			fi
		done

		[ ! -z "$(echo ${seenLine[@]} | grep 2)" ] && let pairs++
		[ ! -z "$(echo ${seenLine[@]} | grep 3)" ] && let triplets++

		unset seenLine
	done < $1

	echo "Checksum: $(($pairs*$triplets))"
}

function part2 {
	while IFS='' read -r line; do
	    i=0
	    while [ $i -lt ${#line} ]; do
	        
	        let i++
	        regex=$(echo $line | sed "s/[a-z]/./$i")

	        RES=$(grep "$regex" $1 | wc -l)

	        if [ $RES -eq 2 ]; then
	            echo "Key: $(echo $regex | sed 's/\.//')"
	            exit 0
	        fi
	    done

	done < "$1"
}

part1 $1
part2 $1