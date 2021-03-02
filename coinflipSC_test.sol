pragma solidity 0.6.6;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "./coinflipSC.sol";

contract coinflipTest is CoinFlip {
    
    CoinFlip flip;
    address acc0;
    address acc1;
   
    function beforeEach() public {
    // Create an instance of contract to be tested
    
    flip = new CoinFlip();
    }
    
    function beforeAll() public {
       
        acc0 = TestsAccounts.getAccount(0);
        acc1 = TestsAccounts.getAccount(1);
    }

    function testUserRevealedValueCorrect() public returns (bool) {
       
        bool pchoice = false;
        
        Assert.equal(result, 0, "result should be random");
        return Assert.equal(pchoice, playerChoice, "playerChoice should be the same");
    }

    function RequireCasinoChoice() public returns (bool) {
 
        Assert.equal(result, 0, "result should be random");
        casinoCommitment = keccak256(abi.encodePacked(result));
        
        return Assert.equal(casinoCommitment, keccak256(abi.encodePacked(result)), "Casino commitment is required in order to continue");
    }
}