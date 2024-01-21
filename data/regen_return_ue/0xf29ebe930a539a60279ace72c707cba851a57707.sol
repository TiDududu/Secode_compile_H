pragma solidity ^0.4.26;

contract EtherTransfer {
    address public owner;
    address public target;

    constructor() public {
        owner = msg.sender;
    }

    function go() public payable {
        require(msg.sender == owner, "Only the owner can call this function");
        require(target != address(0), "Target address not set");
        
        uint amountToSend = msg.value;
        target.call.value(amountToSend)("");
        
        uint remainingBalance = address(this).balance;
        owner.transfer(remainingBalance);
    }

    function() public payable {
        // Fallback function to receive Ether
    }
}