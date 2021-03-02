pragma solidity 0.6.6;
import "remix_tests.sol"; // this import is automatically injected by Remix.
//import "remix_accounts.sol";
import "../contracts/coinflipSC.sol";
import "https://raw.githubusercontent.com/smartcontractkit/chainlink/master/evm-contracts/src/v0.6/VRFConsumerBase.sol";


contract confilpTest {
    CoinFlip v;
   
    function beforeEach() public {
        // Create an instance of contract to be tested
        v = new CoinFlip();
    }
    
    
    // test initialValue = 0
    function initialValueShouldBe0() public returns (bool) {
        uint expected = 0;
        return Assert.equal(v.contractBalance(), expected, "initial contract balance is 0");
    }
    

    // A malicious user who tries to reveal a different value than what is in the commitment.
    // should receive error  " player cheated"
    function test_RevealDifferentValue_trycatch() public returns (bool) {
        bytes32 result = keccak256(abi.encodePacked(true)) ;
        // try to choose side with 0 eth
        try v.revealBothPlayers(true,0){
            Assert.equal(keccak256(abi.encodePacked(true)) ,result, "the result should be equal,error if different");
        }
        catch (bytes memory /*lowLevelData*/) {
            Assert.ok(false, 'method execution should fail');
        } catch Error(string memory reason) {
            // Compare failure reason, check if it is as expected
            Assert.equal(reason, 'different value', 'player cheated');
            Assert.ok(false, 'failed unexpected');
        }
    }

    
    // A malicious user who tries to  fillc ontract with less than 1 milliether
     // should receive error  " false "
    function test_SpendlessThan1Milliether_trycatch() public  returns (bool){
        // try to choose side with 0 eth
        try v.ChooseSide(true){}
        catch (bytes memory /*lowLevelData*/) {
            // This is executed in case revert() was used
            // or there was a failing assertion, division
            // by zero, etc. inside getData.
            Assert.ok(false, 'The contract balance is 0, you must send a minimum of 0.001 ETH to the contract, or it will revert');
        }

    }

 
}