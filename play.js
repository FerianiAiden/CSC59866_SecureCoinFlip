let tokens;
function toggleErrorPopup(){
    document.getElementById("popup-error").classList.toggle("active");
    
  }

function toggleTokenPopup(){
    document.getElementById("popup-token").classList.toggle("active");
    
  }

function initToken(){
  //sets storagesession var, displays tokens on screen
  //sessionStorage.setItem("tokens","Tokens: 0"); // so tokens stays the same after reload, tostring with base 10
  if(sessionStorage.getItem("tokens")==null ){
     document.getElementById("token-display").innerHTML = "Tokens: 0";
  }
  else {
   document.getElementById("token-display").innerHTML = "Tokens: "+ sessionStorage.getItem("tokens");
  }
  
}

async function loadWeb3() {
   //connects to metamask via web3
   
   
   if(window.ethereum){
     var web3js = new Web3(window.ethereum);
     await ethereum.enable();

     //can use web3 with metamask
     // after this go to game page
     sessionStorage.setItem("tokens","0");
     location.replace('/play.html');
 
   }

   else if(window.web3){
     //older versions of metamask
     web3js = new Web3(window.web3.currentProvider);
   }
   else{
     //they dont have metamask, popup shows up asking to install
     toggleErrorPopup();
   }
 
  }

async function sendtx(){
     //not used anywhere, might be useful for the future
     const accounts = await web3js.eth.getAccounts();
     const network = await web3js.eth.net.getNetworkType();
     if(network!="ropsten"){
       window.alert("you arent on ropsten.Please switch");
     }
     
     //below code to send tx
     var txDetails ={
       // hard coded the addresses and amt to test, will get addresses and amt from web3 if this function is used
      from: '0x6DE29c6a03E2694C3217820ed2e595E24f1145B9',
      
       to: '0x456a6aAB3e1D116efdC5D7ae068156469CBef892',
       value: 5954975943824,
       chain: "ropsten"
     }

     await web3js.eth.sendTransaction(txDetails);
  }
  
function validateTokenInput(evt){
    //force users to enter numeric values when asked to enter amt of tokens
    var input = String.fromCharCode(evt.which);
    if(!(/[0-9]/.test(input))){
      evt.preventDefault();
    }
    
  }

async function convertToToken(){
    //check what they entered and their balance, if good, convert, save the number of tokens, close popup.
    //if not, display error
    let web3js = new Web3(window.ethereum);
    await ethereum.enable;
    const accounts = await web3js.eth.getAccounts();
    const weiBalance = await web3js.eth.getBalance(accounts[0]); //gives balance in wei
    var milliEtherBalance = await web3js.utils.fromWei(weiBalance,'milliether'); //balance in milliether, string type
    milliEtherBalance = parseInt(milliEtherBalance,10); //convert to number 
     tokens = document.getElementById("token-input").value;
    if(tokens == null || tokens == 0){
      //say please enter an amount
      window.alert("Please enter an amount");
      document.getElementById("token-input").value ="";
    }
    
    else if(tokens <= milliEtherBalance){
    sessionStorage.setItem("tokens",tokens.toString(10)); // so tokens stays the same after reload, tostring with base 10
    document.getElementById("token-display").innerHTML ="Tokens: "+ sessionStorage.getItem("tokens");
    document.getElementById("token-input").value ="";
    toggleTokenPopup(); 
    }
    else{
      //case where they entered more tokens more tokens than they can afford. do validation error message
      window.alert("You have entered more tokens than you can afford. Please try again");
      document.getElementById("token-input").value ="";
    }
    
  }
  

  


