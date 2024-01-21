pragma solidity ^0.4.26;

contract MiCoin {
    address public owner;
    mapping(address => uint) public balances;

    constructor() public {
        owner = msg.sender;
    }

    function mint(address investor, uint amount) public {
        require(msg.sender == owner, "Only the owner can mint tokens");
        balances[investor] += amount;
    }

    function buy() public payable {
        uint amount = msg.value;
        balances[msg.sender] += amount;
    }

    function transfer(address to, uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}
