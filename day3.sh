#!/bin/bash
declare -A fabric
claimNumber=0
x0=0
y0=0
xMax=0
yMax=0

function translate {
	local vals=($(echo $1 | grep -Po '\d*'))
	claimNumber=${vals[0]}
	x0=$((${vals[1]}+1))
	y0=$((${vals[2]}+1))
	xMax=$((${vals[3]}+$x0))
	yMax=$((${vals[4]}+$y0))
}


function part1 {
	while IFS= read -r claim; do
		translate "$claim"

		x=$x0
		while [ $x -lt $xMax ]; do
			y=$y0
			while [ $y -lt $yMax ]; do
				if [ -z "${fabric["$x,$y"]}" ]; then
					fabric["$x,$y"]="$claimNumber"
				else
					fabric["$x,$y"]="X"
				fi
				let y++
			done
			let x++
		done
	done < $1

	r=0
	for val in ${fabric[@]}; do
		if [[ $val = 'X' ]]; then
			let r++
		fi
	done

	echo $r;
}

function part2 {
	while IFS= read -r claim; do
		translate "$claim"

		x=$x0
		while [ $x -lt $xMax ]; do
			y=$y0
			while [ $y -lt $yMax ]; do
				if [[ ${fabric["$x,$y"]} = 'X' ]]; then
					continue 3
				fi
				let y++
			done
			let x++
		done
		echo "Unbroken: $claimNumber"
	done < $1
}

part1 $1
part2 $1