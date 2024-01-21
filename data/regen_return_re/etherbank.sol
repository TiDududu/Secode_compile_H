pragma solidity ^0.4.26;

contract EtherBank {
    mapping(address => uint) public balances;

    function getBalance(address user) public view returns (uint) {
        return balances[user];
    }

    function addToBalance() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
    }

    function withdrawBalance(uint amount) public {
        require(amount > 0 && amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}