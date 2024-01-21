pragma solidity ^0.4.26;

contract CoinKickingGame {
    address public owner;
    uint public targetBlockNumber;
    uint public blocksPerKick;
    uint public costToKick;
    uint public currentValue;
    address public lastKicker;
    mapping(address => uint) public shares;

    constructor(uint _targetBlockNumber, uint _blocksPerKick, uint _costToKick) public {
        owner = msg.sender;
        targetBlockNumber = _targetBlockNumber;
        blocksPerKick = _blocksPerKick;
        costToKick = _costToKick;
    }

    function kickTheCoin() public payable {
        require(msg.value == costToKick, "Incorrect amount sent");
        require(isGameActive(), "Game is not active");
        
        currentValue += msg.value;
        lastKicker = msg.sender;
    }

    function withdrawShares() public {
        require(!hasWinner(), "Game has a winner");
        
        uint amount = shares[msg.sender];
        shares[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function checkShares(address player) public view returns (uint) {
        return shares[player];
    }

    function isGameActive() public view returns (bool) {
        return block.number < targetBlockNumber;
    }

    function hasWinner() public view returns (bool) {
        return block.number >= targetBlockNumber;
    }

    function getCurrentValue() public view returns (uint) {
        return currentValue;
    }

    function getLastKicker() public view returns (address) {
        return lastKicker;
    }

    function pullShares() public {
        uint amount = shares[msg.sender];
        shares[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function airDrop(address player) public payable {
        require(msg.sender == owner, "Only owner can airdrop");
        player.transfer(msg.value);
    }

    function getTargetBlockNumber() public view returns (uint) {
        return targetBlockNumber;
    }

    function getBlocksLeftInCurrentKick() public view returns (uint) {
        uint blocksLeft = targetBlockNumber - block.number;
        return blocksLeft % blocksPerKick;
    }

    function getNumberOfBlocksPerKick() public view returns (uint) {
        return blocksPerKick;
    }

    function getCostToKick() public view returns (uint) {
        return costToKick;
    }
}