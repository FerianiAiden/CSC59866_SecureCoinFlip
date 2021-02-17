pragma solidity 0.8.1;

    contract CoinFlip{
      
        uint256 public betAmount >= 1.0 finney;
        address public player;
        bool public result;
        bool public resultCommitment;
        bytes32 public playersCommitment;
        bool public Pchoice;
        bool public Pmade_choice = false;
        bool public coinRevealed = false;
        uint256 public expiration = 2**256-1; //Almost infinite

        modifier onlyPlayer(){
        require(msg.sender == player);
        }

        constructor(bytes32 _resultCommitment, bool _result, bytes32 _playersCommitment, address _player) 
            public payable onlyPlayer{
            require(msg.value == betAmount);
            require(_player != address(0));
            playersCommitment = _playersCommitment;
            resultCommitment = _resultCommitment;
            player = _player;
            result = _result;
        }

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




// Executed when player wants to make their choice via paying bet 
// true = heads, false = tails
     
        function  ChooseSide(bool _Pchoice) public payable onlyPlayer{
            require(msg.value == betAmount);
            require(!Pmade_choice);
            Pchoice = _Pchoice;
            Pmade_choice = true;
            expiration =  now + 2 hours; 
        }

        function revealFlip(bool result, uint256 nonce) public {
            require(Pmade_choice);
            require(keccak256(abi.encodePacked(result, nonce)) == resultCommitment);
            require(expiration > now);

            //For a game to start:
            Pmade_choice = false;
            coinRevealed = true;
            expiration = 2**256-1;

            if(result == Pchoice){
                player.transfer(2*betAmount);
            } else {
                /*/ u lose hahahahahahahaha /*/
            }
        }

        function newGame(bytes42 _resultCommitment, address _player) public payable onlyPlayer {
            require(msg.value == betAmount);
            require(coinRevealed);
            require(_player != address(0));
            require(!Pmade_choice);

            coinRevealed = false;
            resultCommitment = _resultCommitment;
            player = _player;
        }

        }






    


    }

