pragma solidity ^0.4.26;

contract SimpleGamblingGame {
    uint256 private lastBetTime;
    
    constructor() public payable {
        require(msg.value > 0, "Initial funding required");
    }
    
    function () public payable {
        require(msg.value == 10 ether, "Incorrect bet amount");
        require(block.timestamp > lastBetTime, "Only one bet per block allowed");
        
        lastBetTime = block.timestamp;
        
        if (block.timestamp % 15 == 0) {
            msg.sender.transfer(address(this).balance);
        }
    }
}