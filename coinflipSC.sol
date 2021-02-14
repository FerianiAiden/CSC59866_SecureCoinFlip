pragma solidity 0.8.1;
// 2.8.2021
//We need to import the following to utilize the consume randomness functionality of Chainlink VRF
import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/evm-contracts/src/v0.6/VRFConsumerBase.sol";


// declaring a variable public will enable the SC to display the variable's value to user
contract CoinFlip is VRFConsumerBase{
  uint public result;
  bytes32 public choice;
  bytes32 public reqId;
  uint256 public randomVal;

 
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
constructor(address _vrfCoordinator, address _link) VRFConsumerBase(_vrfCoordinator, _link) public {
    }

function fulfillRandomness(bytes32 requestId, uint256 randomness) external override {
        reqId = requestId;
        randomVal = randomness;
    }
    
}
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