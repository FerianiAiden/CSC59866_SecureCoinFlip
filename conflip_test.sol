pragma solidity 0.6.6;
import "remix_tests.sol"; // this import is automatically injected by Remix.
//import "remix_accounts.sol";
import "../contracts/coinflipSC.sol";

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
    
    // malicious user who tries to  fillc ontract with less than 1 milliether
    function test_spendlessthan1milliether_trycatch() public  returns (bool){
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