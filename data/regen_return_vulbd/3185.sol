pragma solidity ^0.4.26;

contract Token {
    mapping(address => uint) public balances;
    address public owner;
    uint public refundTime;

    constructor() public {
        owner = msg.sender;
    }

    function transfer(address to, uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function refundTokens(address to, uint amount) public {
        require(msg.sender == owner, "Only owner can refund tokens");
        require(now >= refundTime, "Refund time not reached");
        require(balances[owner] >= amount, "Insufficient balance for refund");
        balances[owner] -= amount;
        balances[to] += amount;
    }
}