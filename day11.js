function getPower(x, y, serial){
	let power=((x+10)*y+serial)*(x+10);
	return parseInt(power/100)-parseInt(power/1000)*10-5;
}

function buildGrid(serial){
	let grid = Array(300);
	for(let i=0;i<300;i++){
		grid[i]=Array(300).fill('.');
	}

	for(let x=1;x<=300;x++){
		for(let y=1;y<=300;y++){
			grid[y-1][x-1]=getPower(x,y,serial);
		}
	}

	return grid;
}

function findHighestSquare(grid,size){
	let res={
		x:0,
		y:0,
		power:0,
	}
	for(let x=0; x<(300-size); x++){
		for(let y=0; y<(300-size); y++){
			let square=grid.slice(y,y+size).map(a=>a.slice(x,x+size).reduce((a,b)=>a+b));
			let pow=square.reduce((a,b)=>a+b);
			
			if(pow>res.power){
				res={
					x:x+1,
					y:y+1,
					power:pow
				}
			}
		}
	}
	return res;
}

function part1(serial){
	console.log("PART1: "+JSON.stringify(findHighestSquare(buildGrid(serial),3)));
}

function part2(serial){
	buffer=5;
	dec=0;
	let res={
		x:0,
		y:0,
		power:0,
		size:0
	}
	for(let s=1;s<=300;s++){
		let test=findHighestSquare(buildGrid(serial),s);
		if(test.power>res.power){
			dec=0;
			res={...test,size:s};
		}
		else dec++;
		if (dec>buffer) break;
	}
	console.log("PART2: "+JSON.stringify(res));
}
part1(1723);
part2(1723);