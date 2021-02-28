pragma solidity 0.6.6;
import "remix_tests.sol"; // this import is automatically injected by Remix.
//import "remix_accounts.sol";
import "../contracts/MyContract.sol";

contract confilpTest {
    CoinFlip v;
   
    function beforeEach() public {
    // Create an instance of contract to be tested
    v = new CoinFlip();
    }
    // test initialValue 
    function initialValueShouldBe0() public returns (bool) {
        uint expected = 0;
        return Assert.equal(v.contractBalance(), expected, "initial contract balance is 0");
    }
    // malicious user who tries to  fill contract with less than 1 milliether
    function spendlessthan1milliether() public returns (bool) {
        // fillcontract with 0 eth
        v.fillContract();
        // Transaction has been reverted by the EVM. Because the contractbalance is 0,you must send a minimum of 0.001 ETH to the contract, or it will revert .
    }

    
}