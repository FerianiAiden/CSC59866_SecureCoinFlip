console.warn = () => {}; // to suppress web3 warnings
const Web3 = require('web3');
const MongoClient = require('mongodb').MongoClient;
const readline = require('readline');
const assert = require('assert');
//connect to kovan node
var web3 = new Web3('https://kovan.infura.io/v3/7d692b7cfcf04c30ad77e8469bb081a4'); 


//address and dbname for mongodb
const url = 'mongodb+srv://coinflip:blueteam@cluster0.bnxtq.mongodb.net/coinflip?retryWrites=true&w=majority';
const dbName = 'coinflip';

//for the game
var balance = 0; //if they get through sign in, will have their balance in milliether
var address = "";  // if they get through sign in, this will have their address


// for getting user input
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var initUsers = function () {
  rl.question("Enter 0 to make account,1 to sign in or 2 to exit:", function (line) {
  switch (line){
      case "0":
          rl.question("Enter a password for your account:",  async function(password){
            //creates new account
            var account = await web3.eth.accounts.create();
            var encrypedAccount = await web3.eth.accounts.encrypt(account['privateKey'],password); // encrypts their account object with password
            account = null; // get rid of account details

            // now put encryptedAccount to db
            MongoClient.connect(url, function(err, client){
            assert.equal(null, err);
            //console.log("Connected successfully to server")

            var dbo = client.db(dbName);
            dbo.collection("accounts").insertOne(encrypedAccount,function(err,res){
              if(err) throw err;
              console.log("Your address is: ", encrypedAccount['address']);
              console.log("Store this address somewhere as it will be needed for signing in.");
              console.log("To play the game you need ether. Visit https://faucet.kovan.network/ to obtain kovan ether.");
              console.log("Exiting to main menu...");
              initUsers();
              })
          
            client.close();
            });
          })  
          break;
      case "1":
          rl.question("Enter the address for your account: ", async function(addressEntered){
            MongoClient.connect(url, async function(err, client){
              assert.equal(null, err);
              //console.log("Connected successfully to server")
          
              var dbo = client.db(dbName);
              var enc_account = await dbo.collection("accounts").findOne({address: addressEntered},{projection:{_id:0}});
              if(enc_account == null){
                console.log("No such address found. Exiting...");
                initUsers();
              }
              
              rl.question("Enter the password for your account: ",async function (passwordEntered){
                try{
                  await web3.eth.accounts.decrypt(enc_account,passwordEntered);
                  address = enc_account['address'];
                  wei_balance = await web3.eth.getBalance(enc_account['address']);
                  balance = Number(await web3.utils.fromWei(wei_balance,"milliether"));
                  console.log("Your address is: ", address);
                  console.log("Your balance is: ", balance," milliether");
                  rl.pause();
              
                  }
                  catch{
                    console.log("wrong password. Exiting...");
                    initUsers();
                  }
                
              })         
              client.close();
            });
            
          })
          
          break;
      case "2":
        console.log("Exiting...");
        rl.pause();
        break;
      
      default:
          console.log("No such option.");
          initUsers(); //Calling this function again if they didnt input 0,1 or 2
  }
  
  });
};
initUsers();







  
  


  





