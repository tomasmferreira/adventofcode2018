function setCharAt(str,index,chr) {
    if(index > str.length-1) return str;
    return str.substr(0,index) + chr + str.substr(index+1);
}

function extractInfo(inp){
	let input=inp.split('\n');

	let plants="....."+input[0].split(' ')[2]+"......";
	input.splice(0,2)

	let exps=[]

	for(let exp of input){
		exp=exp.split(' ');
		let pattern=exp[0].split('').map(a=>(a=='.')?"\\"+a:a);

		//regex = new RegExp("(?<="+pattern[0]+pattern[1]+")"+pattern[2]+"(?="+pattern[3]+pattern[4]+")", "g");
		regex = new RegExp(pattern.join(''), "i");
		exps.push({
			find:regex,
			subs:exp[2]
		});
	}
	return {
		plants: plants,
		exps: exps
	}
}

function newGen(setup){
	let toSub=[]
	for(let exp of setup.exps){
		let plantation=setup.plants
		let ind=0
		while(match = plantation.match(exp.find)){
			toSub.push({
				i:match.index+2+ind,
				p:exp.subs
			});
			plantation=plantation.substr(match.index+1);
			ind+=match.index+1;
		}
	}
	let plants=setup.plants
	for(let pot of toSub){
		plants=setCharAt(plants,pot.i,pot.p);
	}
	return {...setup,plants:plants}
}

function countPlants(plants){
	let plant=new RegExp("#","g");
	let res=0;
	while ( match = plant.exec(plants) ){
		res+=match.index-5;
	}
	return res;
}

function part1(input) {
	plantStruct=extractInfo(input);

	for(let i=0;i<20;i++){
		plantStruct=newGen(plantStruct);
		plantStruct.plants=plantStruct.plants+".";
	}
	console.log("part1: "+countPlants(plantStruct.plants));
}

function part2() {
	plantStruct=extractInfo(input);

	for(let i=0;i<1000;i++){
		plantStruct=newGen(plantStruct);
		plantStruct.plants=plantStruct.plants+".";
	}
	resultAfter1000=countPlants(plantStruct.plants);
	plantStruct=newGen(plantStruct);
	jump=countPlants(plantStruct.plants)-resultAfter1000;

	console.log("part2: "+((50000000000-1000)*jump+resultAfter1000));
}

input=`initial state: ##.......#.######.##..#...#.#.#..#...#..####..#.##...#....#...##..#..#.##.##.###.##.#.......###....#

.#### => .
....# => .
###.. => .
..#.# => .
##### => #
####. => .
#.##. => #
#.#.# => .
##.#. => #
.###. => .
#..#. => #
###.# => .
#.### => .
##... => #
.#.## => .
..#.. => .
#...# => #
..... => .
.##.. => .
...#. => .
#.#.. => .
.#..# => #
.#.#. => .
.#... => #
..##. => .
#..## => .
##.## => #
...## => #
..### => #
#.... => .
.##.# => #
##..# => #`

part1(input);
part2(input);
