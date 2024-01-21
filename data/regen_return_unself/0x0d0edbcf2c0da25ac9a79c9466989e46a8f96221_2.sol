pragma solidity ^0.4.26;

contract DiceGame {
    address public owner;
    address public settler;
    uint public maxProfit;
    uint public leverage;
    mapping(address => uint) public playerBets;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    modifier onlySettler {
        require(msg.sender == settler, "Only the settler can call this function");
        _;
    }

    function setSettler(address _newSettler) public onlyOwner {
        settler = _newSettler;
    }

    function updateMaxProfit(uint _newMaxProfit) public onlyOwner {
        maxProfit = _newMaxProfit;
    }

    function setLeverage(uint _newLeverage) public onlyOwner {
        leverage = _newLeverage;
    }

    function withdrawFunds(uint _amount) public onlyOwner {
        require(_amount <= address(this).balance, "Insufficient balance");
        owner.transfer(_amount);
    }

    function kill() public onlyOwner {
        selfdestruct(owner);
    }

    function placeBet(uint _playerSeed, bytes32 _seedHash, uint _targetNumber) public payable {
        require(msg.value > 0, "Bet amount should be greater than 0");
        playerBets[msg.sender] = _playerSeed + uint(_seedHash) + _targetNumber;
    }

    function settleBet(uint _randomSeed) public onlySettler {
        uint winningAmount = playerBets[msg.sender] * leverage;
        if (_randomSeed % 6 == 0) {
            msg.sender.transfer(winningAmount);
        }
    }
}