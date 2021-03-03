pragma solidity 0.6.6;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "./coinflipSC.sol";

contract coinflipTest is CoinFlip {
    CoinFlip flip;
    address casino_account;
    address user_account;
   
    function beforeEach() public {
    flip = new CoinFlip();
    }
    
    function beforeAll() public {
        casino_account = TestsAccounts.getAccount(0);
        user_account = TestsAccounts.getAccount(1);
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
