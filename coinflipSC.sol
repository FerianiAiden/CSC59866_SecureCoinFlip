pragma solidity 0.8.1;

    contract CoinFlip {
      
        uint256 public betAmount = 0.001 ether;
        address public player;
        bool public result;
        bytes32 public playersCommitment;
        bool public PlayerChoice;
        bool public Player_Chose = false;
        bool public coinRevealed = false;
        uint256 public expiration = 2**256-1; 

// Call the following function to fund the contract

            mapping (address => uint) balances;
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
}

     // Constructor used to intitialize a new game
        constructor(bytes32 _resultCommitment, bytes32 _playersCommitment, address _player) 
        public payable onlyPlayer{
            require(msg.value >= betAmount);
            require(_player != address(0));

            playersCommitment = _playersCommitment;
            resultCommitment = _resultCommitment;
            player = _player;
        }

// Executed when player wants to make their choice via paying bet 
// true = heads, false = tails
     
        function  ChooseSide(bool _PlayerChoice) public payable onlyPlayer{
            require(msg.value == betAmount);
            require(!Pmade_choice);
            PlayerChoice = _PlayerChoice;
            Player_Chose = true;
            expiration =  now + 1 hours; 
        }
// In this function we are revealing whether or not the player won. 
// The hashed result of the coin must match its commitment, and similarly the hashed player choice must match their comittment
        function revealFlip(bool result, bool PlayerChoice uint256 nonce) public {
            require(Player_Chose);
            require(keccak256(abi.encodePacked(result, nonce)) == resultCommitment);
            require(keccak256(abi.encodePacked(PlayerChoice, nonce)) == playersCommitment);
            require(expiration > now + 5 minutes);

            //For a new game to start:
            Pmade_choice = false;
            coinRevealed = true;
            expiration = 2**256-1;

            if(result == PlayerChoice){
                player.transfer(2*betAmount);
            
        }

        function newGame(bytes42 _resultCommitment, address _player) public payable onlyPlayer {
            require(msg.value == betAmount);
            require(coinRevealed);
            require(_player != address(0));
            require(!Player_Chose);

            coinRevealed = false;
            resultCommitment = _resultCommitment;
            player = _player;
        }

      
    }

       

