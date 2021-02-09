pragma solidity 0.8.1;
// 2.8.2021


// values of variables get written to the blockchain, stored to a database 
// declaring a variable public will enable the SC to display the variable's value to user
contract CoinFlip {
  uint public result;
  bytes32 public choice;

//Event "FlipHistory" is a stream that will log all history of coinflip results. 
// The event can be subsribed to in order to view said results
event FlipHistory(uint hist);

//simply initializing value of result 
constructor() public {
      result = 0;
                     }

//  We'll be using a Chainlink VRF to randomize the result of the coin flip.

// "The random number is generated in a verifiably random fashion, 
// using a public key and a private key to cryptographically prove 
// that the number was random. This random number generation (or RNG) is done 
// across multiple nodes to guarantee that there is no single source of failure, and 
// then XOR’d (a way to combine the answers) to make the final result. "

function FlipCoin() public {



if (result ^ choice == 1)
// if these values don't match the player has lost
{
    
}
else // they have won 
{

}

emit FlipHistory(result);
                            }
    
                    }