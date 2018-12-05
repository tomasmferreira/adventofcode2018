#!/bin/bash
function part1 {
	#apply regex
	res=$(echo $1 | ssed -R -e ":loop" -e "s/$regex//g" -e "t loop")
	echo ${#res}
}

function part2 {
	in=$1

	minLength=99999999
	for unit in {a..z}; do 

		noUnit=$(echo $in | sed "s/$unit//Ig")
		reduced=$(part1 $noUnit)
		if [ $reduced -lt $minLength ]; then
			minLength=$reduced
		fi
	done
	echo $minLength
}
#build regex
regex="aA|Aa"
for char in {b..z}; do 
	regex="$regex|$char${char^^}|${char^^}$char"
done

#Part 1
echo Part1: $(part1 $(cat $1))

#Part 2
echo Part2: $(part2 $(cat $1))
