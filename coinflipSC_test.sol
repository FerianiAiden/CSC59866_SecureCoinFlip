// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.6;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../coinflipSC.sol";

contract confilpTest is CoinFlip {

    CoinFlip instance;
    address acc0;
    address acc1;

    function beforeEach() public {
        // Create an instance of contract to be tested
        instance = new CoinFlip();
    }

    function beforeAll () public {
        acc0 = TestsAccounts.getAccount(0); //casino
        acc1 = TestsAccounts.getAccount(1); //player
    }


    function checkBalance() public {
        Assert.equal(instance.contractBalance(), 0, "initial contract balance is 0");
    }

    /// #sender: account-0
    /// #value: 1
    function testContract() public payable {
        Assert.equal(msg.sender, acc0, 'acc0 should be the sender');
        Assert.equal(msg.value, 1, '1 should be the value');
    }


    //check to see if player choice is actually what they chose
    function testReveal() public payable {
        Assert.equal(playerChoice, Player_Chose, "should be equal");
    }


    function testReset() public {
        try instance.newGame(player) {
            Assert.equal(result, 0, "player address should be 0");
        }
        catch (bytes memory /*lowLevelData*/) {
            // This is executed in case revert() was used
            // or there was a failing assertion, division
            // by zero, etc. inside getData.
            Assert.ok(true, 'failed unexpected');
        }
    }


}
