buildStruct = function(input) {
	let nChildren=input.splice(0,1)[0];
	let nMeta=input.splice(0,1)[0];
	
	let ret={
		nchildren:nChildren,
		children:[],
		metadata:[],
		val:0
	};

	for(let i=0; i<nChildren;i++){
		ret.children.push(buildStruct(input));
    }
	
	ret.metadata=input.splice(0,nMeta);

	if(nChildren==0){
		ret.val=ret.metadata.reduce((a,b)=>a+b);
    }
	else{
		tot=0;
		for(let c of ret.metadata){
			tot+=ret.children[c-1].val;
        }
		ret.val=tot;
    }

	return ret;
}

getMetadataSum = function(node, res) {
    res+=node.metadata.reduce((a,b)=>a+b);
	for(let child of node.children){ 
		res=getMetadataSum(child, res);
    }
	return res;
}

getMetadataSum(buildStruct(document.body.innerText.split(' ').map(a=>parseInt(a))),0)