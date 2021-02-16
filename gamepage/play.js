const coin = document.querySelector('#coin');
const button = document.querySelector('#flip');
const button2 = document.querySelector('#flip2');
const status = document.querySelector('#status');
const heads = document.querySelector('#headsCount');
const tails = document.querySelector('#tailsCount');
const ether = document.querySelector('#etherCount');

let headsCount = 0;
let tailsCount = 0;
let etherCount = 10;


function deferFn(callback, ms) {
  setTimeout(callback, ms); 
}

function HeadprocessResult(result) {
   if (result === 'heads' && etherCount >= 1) {
      headsCount++;
      etherCount = etherCount+1;
      ether.innerText = etherCount;
      heads.innerText = headsCount;
      status.innerText = "You win 1 Ether!";
    } else if(result === 'tails' && etherCount >= 1){
      tailsCount++;
      etherCount = etherCount-1;
      ether.innerText = etherCount;
      tails.innerText = tailsCount;
      status.innerText = "You lose 1 Ether!";
    }
    //status.innerText = result.toUpperCase();
    //status.innerText = "You won";
    if (etherCount < 1){
      status.innerText = "not enough ether to bet!";
    }
}

function TailprocessResult(result) {
  if (result === 'heads' && etherCount >= 1) {
     headsCount++;
     etherCount = etherCount-1;
     ether.innerText = etherCount;
     heads.innerText = headsCount;
     status.innerText = "You lose 1 Ether!";
   } else if(result === 'tails' && etherCount >= 1) {
     tailsCount++;
     etherCount = etherCount+1;
     ether.innerText = etherCount;
     tails.innerText = tailsCount;
     status.innerText = "You win 1 Ether!";
   }
   //status.innerText = result.toUpperCase();
   //status.innerText = "You won";
   if (etherCount < 1){
    status.innerText = "not enough ether to bet!";
  }
}

function HeadflipCoin() {
  coin.setAttribute('class', '');
  const random = Math.random();
  const result = random < 0.5 ? 'heads' : 'tails';
 deferFn(function() {
   coin.setAttribute('class', 'animate-' + result );
   deferFn(HeadprocessResult.bind(null, result), 2900);
 }, 100);
}

function TailflipCoin() {
  coin.setAttribute('class', '');
  const random = Math.random();
  const result = random < 0.5 ? 'heads' : 'tails';
 deferFn(function() {
   coin.setAttribute('class', 'animate-' + result );
   deferFn(TailprocessResult.bind(null, result), 2900);
 }, 100);
}

button.addEventListener('click', HeadflipCoin);
button2.addEventListener('click', TailflipCoin);


