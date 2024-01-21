pragma solidity ^0.4.26;

contract BettingContract {
    address public owner;
    bool public locked;
    
    constructor() public {
        owner = msg.sender;
        locked = false;
    }
    
    function bet() public payable {
        require(msg.value == 1 ether, "Please send exactly 1 ether to place a bet");
        require(!locked, "Betting is currently locked");
        
        if (random() == 1) {
            msg.sender.transfer(2 ether);
        }
    }
    
    function lock() public {
        require(msg.sender == owner, "Only the owner can lock the betting process");
        locked = true;
    }
    
    function unlock() public {
        require(msg.sender == owner, "Only the owner can unlock the betting process");
        locked = false;
    }
    
    function own(address newOwner) public {
        require(msg.sender == owner, "Only the owner can transfer ownership");
        owner = newOwner;
    }
    
    function releaseFunds() public {
        require(msg.sender == owner, "Only the owner can release funds");
        msg.sender.transfer(address(this).balance);
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;
    }
    
    function () public payable {
        bet();
    }
}