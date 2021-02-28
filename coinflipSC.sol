pragma solidity 0.6.6;
import "https://raw.githubusercontent.com/smartcontractkit/chainlink/master/evm-contracts/src/v0.6/VRFConsumerBase.sol";
// for vrf chainlink
    contract CoinFlip is VRFConsumerBase {
      
        uint256 public betAmount;
        address payable public player;  // players address
        
        
        bool public playerChoice; // players guess(heads or tails)
        bytes32 public playerCommitment; // players hash
        
        bool public casinoChoice; //casino guess(heads or tails)
        bytes32 public casinoCommitment; //casino hash
        
        bool public Player_Chose;
        bool public coinRevealed;
        uint256 public expiration; 
        
        // new variables bro
        mapping (address => uint) balances; // Keeps track of the transactions made with this contract via player address
        address[] _players; // this is used in ChooseSide - will add the address of the player that pays bet fee 
        
        
     
        
       
        
        //for chainlink vrf
        bytes32 internal keyHash;
        uint256 internal fee;
        uint256 public result; // random number vrf generates, getRandomNumber function needs to be called to have a number
        
        //constructor
        constructor () 
        VRFConsumerBase(
            0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9, // VRF Coordinator
            0xa36085F69e2889c224210F603D836748e7dC0088  // LINK Token
        ) public
    {
        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
        fee = 0.1 * 10 ** 18; // 0.1 LINK
        betAmount = 0.001 ether;
        Player_Chose = false;
        coinRevealed = false;
        expiration = 2**256-1; 
    }
    
        
    /** 
     * Requests randomness from a user-provided seed, seed can be any number
     */
    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }
    
    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32, uint256 randomness) internal override {
        result = randomness;
    }
    
// Call the following function to fund the contract

            
            function fillContract() external payable {
                if(msg.value < 1 ether) {
                    revert();
            }
            balances[msg.sender] += msg.value;
        }
// Call the following to view the contract's current balance
            function contractBalance() external view returns (uint) {
                return address(this).balance;
            }

modifier onlyPlayer(){
    require(msg.sender == player);
    _;
}

     

// Executed when player wants to make their choice via paying bet 
// true = heads, false = tails
     
        function  ChooseSide(bool _PlayerChoice) public payable onlyPlayer{
            require(msg.value >= betAmount);
            require(!Player_Chose);
            betAmount = msg.value;
            
            playerChoice = _PlayerChoice;
            Player_Chose = true;
            expiration =  now + 1 hours; 
            _players.push(msg.sender);
        }
        
// In this function we are revealing whether or not the player won. 
// The hashed result of the coin must match its commitment, and similarly the hashed player choice must match their comittment
        function revealFlip(uint256 _result,  uint256 nonce) public {
            require(Player_Chose);
            //require(keccak256(abi.encodePacked(result, nonce)) == resultCommitment);
            require(keccak256(abi.encodePacked(playerChoice, nonce)) == playerCommitment);
            require(expiration > now + 5 minutes);
           
            
           
            //For a new game to start:
            Player_Chose = false;
            coinRevealed = true;
            expiration = 2**256-1;
            
            
}
        /*/ NEW VVVV /*/
        function determineWinner() public {
            bytes1 temp1;
            bytes1 temp2;
            if (playerChoice = true){
                temp1 = 0x01; 
            } 
            else {
                temp1 = 0x0;
            }
            if (casinoChoice = true) {
                temp2 = 0x01;
            }
            else {
                temp2 = 0x0;
            }
            
            if (temp1 ^ temp2 == 0){
                player.transfer(2*betAmount);
            }
        
        }
        /*/ NEW functions VVVVVV /*/ 
        function newGame(bytes32 _casinoCommitment, address payable _player) public payable onlyPlayer {
            require(msg.value >= betAmount);
            require(coinRevealed);
            require(_player != address(0));
            require(!Player_Chose);

            coinRevealed = false;
            casinoCommitment = _casinoCommitment;
            player = _player;
        }
        
        function ForfeitGame() public onlyPlayer { //If the Casino refuses to reveal the coin result 
            require(now > expiration);
            require(Player_Chose);
            //we may have to require that the random value has already been produced, 
            player.transfer(betAmount);
            Player_Chose = false;
            
            
        }
        
    }