pragma solidity ^0.4.26;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "Multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "Division by zero");
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Subtraction underflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Addition overflow");
        return c;
    }
}

library utils {
    function inArray(uint256[] storage array, uint256 value) internal view returns (bool) {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }

    function inArray(address[] storage array, address value) internal view returns (bool) {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }
}

contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract GuessEthEvents is Ownable {
    event GamePaused(address indexed pauser);
    event GameResumed(address indexed resumer);
    event OddsSet(uint256 odds);
    event ReserveFundSet(uint256 amount);
    event TargetNumberSet(uint256 number);
    event BetMade(address indexed player, uint256 amount, uint256 number);
    event NumberDrawn(uint256 number);
    event FundsWithdrawn(address indexed withdrawer, uint256 amount);
}

contract GuessEth is GuessEthEvents {
    using SafeMath for uint256;
    using utils for uint256[];
    using utils for address[];

    bool public gamePaused;
    uint256 public odds;
    uint256 public reserveFund;
    uint256 public targetNumber;
    uint256[] public bets;
    address[] public players;

    modifier isHuman() {
        require(tx.origin == msg.sender, "Human users only");
        _;
    }

    function pauseGame() public onlyOwner {
        gamePaused = true;
        emit GamePaused(msg.sender);
    }

    function resumeGame() public onlyOwner {
        gamePaused = false;
        emit GameResumed(msg.sender);
    }

    function setOdds(uint256 _odds) public onlyOwner {
        odds = _odds;
        emit OddsSet(_odds);
    }

    function setReserveFund(uint256 _amount) public onlyOwner {
        reserveFund = _amount;
        emit ReserveFundSet(_amount);
    }

    function setTargetNumber(uint256 _number) public onlyOwner {
        targetNumber = _number;
        emit TargetNumberSet(_number);
    }

    function makeBet(uint256 _number) public payable isHuman {
        require(!gamePaused, "Game is paused");
        require(msg.value > 0, "Invalid bet amount");
        bets.push(msg.value);
        players.push(msg.sender);
        emit BetMade(msg.sender, msg.value, _number);
    }

    function drawNumber() public onlyOwner {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1)))) % 100;
        targetNumber = randomNumber;
        emit NumberDrawn(randomNumber);
    }

    function withdrawFunds() public {
        uint256 totalFunds = address(this).balance;
        require(totalFunds > 0, "No funds available");
        uint256 amountToSend = totalFunds.sub(reserveFund);
        reserveFund = 0;
        msg.sender.transfer(amountToSend);
        emit FundsWithdrawn(msg.sender, amountToSend);
    }
}