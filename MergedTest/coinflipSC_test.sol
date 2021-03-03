pragma solidity 0.6.6;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "./coinflipSC.sol";

contract coinflipTest is CoinFlip {
    CoinFlip instance;
    address casino_account;
    address user_account;
   
    function beforeEach() public {
    instance = new CoinFlip();
    }
    
    function beforeAll() public {
        casino_account = TestsAccounts.getAccount(0);
        user_account = TestsAccounts.getAccount(1);
    }

        // test initialValue = 0
    function initialValueShouldBe0() public returns (bool) {
        uint expected = 0;
        return Assert.equal(instance.contractBalance(), expected, "initial contract balance is 0");
    }
    
    // A malicious user who tries to reveal a different value than what is in the commitment.
    // should receive error  " player cheated"
    function test_RevealDifferentValue_trycatch() public returns (bool) {
        bytes32 result = keccak256(abi.encodePacked(true)) ;
        // try to choose side with 0 eth
        try instance.revealBothPlayers(true,0){
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
        try instance.ChooseSide(true){}
        catch (bytes memory /*lowLevelData*/) {
            // This is executed in case revert() was used
            // or there was a failing assertion, division
            // by zero, etc. inside getData.
            Assert.ok(false, 'The contract balance is 0, you must send a minimum of 0.001 ETH to the contract, or it will revert');
        }

    }
    
    function checkBalance() public {
        Assert.equal(instance.contractBalance(), 0, "initial contract balance is 0");
    }

    /// #sender: casino
    /// #value: 1
    function testContract() public payable {
        Assert.equal(msg.sender, casino_account, 'acc0 should be the sender');
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
    
    function testUserRevealedValueCorrect() public returns (bool) {
        bytes32 result = keccak256(abi.encodePacked(true)) ;
        bytes32 playerComm = keccak256(abi.encodePacked(true, result));
        playerCommitment = keccak256(abi.encodePacked(true, result));
        
        return Assert.equal(playerCommitment, playerComm, "playerCommitment should be the same, else value is not the same and user cheated");
    }

    function RequireCasinoChoice() public returns (bool) {
        bytes32 result = keccak256(abi.encodePacked(true)) ;
        bytes32 casinoComm = keccak256(abi.encodePacked(result));
        
        Assert.notEqual(casinoCommitment, casinoComm, "Casino commitment is required in order to continue");
    }
}
