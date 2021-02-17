const coin = document.querySelector('#coin');
const button = document.querySelector('#flip');
const button2 = document.querySelector('#flip2');
const button3 = document.querySelector('#top_up');
const button4 = document.querySelector('#transfer');
const status = document.querySelector('#status');
const heads = document.querySelector('#headsCount');
const tails = document.querySelector('#tailsCount');
const token = document.querySelector('#tokensCount');
const text1 = document.querySelector('#textboxmsg');


let headsCount = 0;
let tailsCount = 0;
let tokenCount = 0;


function deferFn(callback, ms) {
  setTimeout(callback, ms); 
}

function HeadprocessResult(result) {
    var textBoxValue = Number(document.getElementById('TEXTBOX_ID').value);
    if (tokenCount <= textBoxValue ){
    status.innerText = "not enough token to bet!";
    }
    if (result === 'heads' && textBoxValue  <= tokenCount ) {  
      headsCount++;
      tokenCount = tokenCount+ textBoxValue;
      token.innerText = tokenCount;
      heads.innerText = headsCount;
      status.innerText = "You win "+ textBoxValue+ " Token!";

    } else if(result === 'tails' && textBoxValue  <= tokenCount ){
      tailsCount++;
      tokenCount = tokenCount- textBoxValue;
      token.innerText = tokenCount;
      tails.innerText = tailsCount;
      status.innerText = "You lose "+ textBoxValue+" Token!";
    }
    //status.innerText = result.toUpperCase();
    //status.innerText = "You won";
    if (textBoxValue === "" ){
      text1.innerText = "type your value!";
    }
    text1.innerText = "You entered: " +textBoxValue+" Token";
}

function TailprocessResult(result) {
  var textBoxValue = Number(document.getElementById('TEXTBOX_ID').value);
  if (tokenCount <= textBoxValue ){
    status.innerText = "not enough token to bet!";
    }
  if (result === 'heads' && textBoxValue  <= tokenCount) {
     headsCount++;
     tokenCount = tokenCount- textBoxValue;
     token.innerText = tokenCount;
     heads.innerText = headsCount;
     status.innerText = "You lose "+ textBoxValue+ " Token!";
   } else if(result === 'tails' && textBoxValue  <= tokenCount) {
     tailsCount++;
     tokenCount = tokenCount+ textBoxValue;;
     token.innerText = tokenCount;
     tails.innerText = tailsCount;
     status.innerText = "You win "+ textBoxValue+ " Token!";
   }
   //status.innerText = result.toUpperCase();
   //status.innerText = "You won";
   text1.innerText = "You entered: " +textBoxValue+" Token";
}


function top_up() {
  var topupValue = Number(document.getElementById('TEXTBOX_TOPUP').value);
  tokenCount = tokenCount + topupValue;
  token.innerText = tokenCount;
  status.innerText = "Added " + topupValue +" tokens";
}

function transfer() {
  var transValue = Number(document.getElementById('TEXTBOX_TRANS').value);
  if (tokenCount >= transValue ){
    tokenCount = tokenCount - transValue;
    token.innerText = tokenCount;
    status.innerText = "Transferred " + transValue +" ether to your wallet successfully.";
  }
  else{
    status.innerText = "Not enough tokens";
  }
}


function flipCoin() {
  coin.setAttribute('class', '');
  const random = Math.random();
  const result = random < 0.5 ? 'heads' : 'tails';
 deferFn(function() {
   coin.setAttribute('class', 'animate-' + result );
   deferFn(HeadprocessResult.bind(null, result), 2900);
 }, 100);
}

function flipCoin2() {
  coin.setAttribute('class', '');
  const random = Math.random();
  const result = random < 0.5 ? 'heads' : 'tails';
 deferFn(function() {
   coin.setAttribute('class', 'animate-' + result );
   deferFn(TailprocessResult.bind(null, result), 2900);
 }, 100);
}

button.addEventListener('click', flipCoin);
button2.addEventListener('click', flipCoin2);
button3.addEventListener('click', top_up);
button4.addEventListener('click', transfer);


