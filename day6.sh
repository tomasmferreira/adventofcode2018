#!/bin/bash
declare -A points
declare -A distances
declare -A regions

boxMaxX=0
boxMaxY=0

#get point coordinates
nPoints=0
while IFS= read -r line; do
	let nPoints++
	coords=($(echo $line | sed 's/,//'))
	
	points[${nPoints}X]=${coords[0]}
	points[${nPoints}Y]=${coords[1]}

	[ ${coords[0]} -gt $boxMaxX ] && boxMaxX=${coords[0]}
	[ ${coords[1]} -gt $boxMaxY ] && boxMaxY=${coords[1]}
done < $1

let boxMaxX++
let boxMaxY++

function part1 {
	#draw regions
	for ((i=1;i<=nPoints;i++)); do
		for ((x=0;x<=boxMaxX;x++)); do
			for ((y=0;y<=boxMaxY;y++)); do
				let distInX=${points[${i}X]}-$x
				let distInY=${points[${i}Y]}-$y
				distInX=${distInX#-}
				distInY=${distInY#-}
				let totalDist=distInX+distInY

				if [ ! -z ${distances[$x$y]} ]; then
					if [ ${distances[$x$y]} -gt $totalDist ]; then
						distances[$x$y]=$totalDist
						regions[$x$y]=$i
					elif [ ${distances[$x$y]} -eq $totalDist ]; then
						regions[$x$y]='.'
					fi
				else
					distances[$x$y]=$totalDist
					regions[$x$y]=$i
				fi
			done
		done
	done

	#count regions
	higher=0
	best=0
	for ((x=0;x<=boxMaxX;x++)); do
		for ((y=0;y<=boxMaxY;y++)); do
			point=${regions[$x$y]}
			if [[ ! $point = "." ]] && [[ ! $scores[$point] = "infinite" ]]; then
				if [ $x -eq $boxMaxX ] || [ $y -eq $boxMaxY ] || [ $x -eq 0 ] || [ $y -eq 0 ]; then
					scores[$point]="infinite" 
				else
					score=$((${scores[$point]}+1))
					scores[$point]=$score
					if [ $score -gt $higher ]; then
						higher=$score
						best=$point
					fi
				fi
			fi
		done
	done

	echo "Best point is #$best with $higher points"
}

function drawMap {
	#draw Map
	for ((y=0;y<boxMaxY;y++)); do
		for ((x=0;x<boxMaxX;x++)); do
			echo -n ${regions[$x$y]}
		done
		echo
	done
}

function part2 {
	for ((x=0;x<=boxMaxX;x++)); do
		for ((y=0;y<=boxMaxY;y++)); do
			totalDist=0
			for ((i=1;i<=nPoints;i++)); do
				let distInX=${points[${i}X]}-$x
				let distInY=${points[${i}Y]}-$y
				distInX=${distInX#-}
				distInY=${distInY#-}
				let totalDist=totalDist+distInX+distInY

				distances[$x$y]=$totalDist
			done
		done
	done

	res=0
	for d in ${distances[@]}; do 
		[ $d -lt $1 ] && let res++ 
	done

	echo $res
}

part2 10000