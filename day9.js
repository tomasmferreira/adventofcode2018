function addHere(deque, val){
    let newLink={
        value:val,
        prev:deque,
        next:deque.next
    };
    newLink.prev.next=newLink;
    newLink.next.prev=newLink;
    return newLink;
}

function popThis(deque){
    deque.prev.next=deque.next;
    deque.next.prev=deque.prev;

    return deque.next;
}

function rotate(deque, n, dir){
    for(let i=0;i<n;i++){
        deque = dir>=0 ? deque.next : deque.prev;
    }
    return deque;
}

function newDeque(val){
    let newDeque={
        value:val,
        next:null,
        prev:null,
    }
    newDeque.next=newDeque;
    newDeque.prev=newDeque;
    return newDeque;
}

play = function(player, board, number){
    if(number%23!=0){
        board.marbles=rotate(board.marbles,1,1);
        board.marbles=addHere(board.marbles,number);
    } else {
        board.marbles=rotate(board.marbles,7,-1);
        board.scores[player]+=board.marbles.value+number;
        board.marbles=popThis(board.marbles);
    }
    return board;
}

game = function(nPlayers, lastMarble){
    let board = {
        marbles:newDeque(0),
        curr:0,
        scores:[],
    };
    for(let i=0;i<nPlayers;i++){
        board.scores.push(0);
    }
    player=0;
    for(let i=1; i<=lastMarble; i++){
        board=play(player,board,i);
        player=(player+1)%nPlayers;
    }
    return board;
}

//test
//console.log("Teste: "+game(9,25).scores.reduce((a,b)=>(a>b?a:b)));

//part1
console.log("Part1: "+game(404,71852).scores.reduce((a,b)=>(a>b?a:b)));

//part2
console.log("Part2: "+game(404,7185200).scores.reduce((a,b)=>(a>b?a:b)));

