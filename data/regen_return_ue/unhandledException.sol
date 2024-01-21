pragma solidity ^0.4.26;

contract SimpleBank {
    mapping(address => uint) public balances;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(amount > 0 && amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function refundAll() public {
        require(msg.sender == owner);
        for (uint i = 0; i < address(this).balance; i++) {
            address user = address(i);
            uint amount = balances[user];
            if (amount > 0) {
                balances[user] = 0;
                user.transfer(amount);
            }
        }
    }
}