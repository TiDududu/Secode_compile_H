pragma solidity ^0.4.26;

contract RiskyGame {
    address public owner;
    uint public oldestEntryAmount;
    mapping(address => uint) public entries;

    constructor() public {
        owner = msg.sender;
    }

    function enter() public payable {
        require(msg.value % 100 ether == 0, "Amount must be a multiple of 100 ether");
        entries[msg.sender] = msg.value;
        if (oldestEntryAmount == 0 || msg.value < oldestEntryAmount) {
            oldestEntryAmount = msg.value;
        }
        if (address(this).balance >= oldestEntryAmount * 2) {
            uint amountToPay = oldestEntryAmount;
            oldestEntryAmount = 0;
            entries[msg.sender] = 0;
            msg.sender.transfer(amountToPay);
        }
    }

    function setOwner(address newOwner) public {
        require(msg.sender == owner, "Only the contract owner can call this function");
        owner = newOwner;
    }
}