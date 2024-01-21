pragma solidity ^0.4.26;

contract KickTheCoin {
    address public owner;
    uint public targetBlockNumber;
    uint public blocksPerKick;
    uint public costToKick;
    uint public totalValue;
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
        require(block.number < targetBlockNumber, "Game is over");
        
        totalValue += msg.value;
        shares[msg.sender] += msg.value;
        lastKicker = msg.sender;
    }

    function withdrawShares() public {
        require(!hasWinner(), "Game is over");
        uint amount = shares[msg.sender];
        require(amount > 0, "No shares to withdraw");
        
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
        return block.number >= targetBlockNumber && totalValue > 0;
    }

    function getCurrentValue() public view returns (uint) {
        return totalValue;
    }

    function getLastKicker() public view returns (address) {
        return lastKicker;
    }

    function pullShares(uint amount) public {
        require(shares[msg.sender] >= amount, "Insufficient shares");
        shares[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function airDrop(address player) public payable {
        require(msg.sender == owner, "Only owner can airdrop");
        require(msg.value > 0, "No value sent");
        
        uint remaining = msg.value % costToKick;
        uint share = msg.value - remaining;
        totalValue += share;
        shares[player] += share;
        if (remaining > 0) {
            owner.transfer(remaining);
        }
    }

    function getTargetBlockNumber() public view returns (uint) {
        return targetBlockNumber;
    }

    function getBlocksLeftInCurrentKick() public view returns (uint) {
        if (block.number < targetBlockNumber) {
            return targetBlockNumber - block.number;
        } else {
            return 0;
        }
    }

    function getNumberOfBlocksPerKick() public view returns (uint) {
        return blocksPerKick;
    }

    function getCostToKick() public view returns (uint) {
        return costToKick;
    }
}