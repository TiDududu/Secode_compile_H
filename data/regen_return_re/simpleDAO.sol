pragma solidity ^0.4.26;

contract SimpleDAO {
    mapping(address => uint) public creditBalances;

    function donate(address recipient) public payable {
        require(msg.value > 0);
        creditBalances[recipient] += msg.value;
    }

    function withdraw(uint amount) public {
        require(creditBalances[msg.sender] >= amount);
        msg.sender.transfer(amount);
        creditBalances[msg.sender] -= amount;
    }

    function queryCredit(address user) public view returns (uint) {
        return creditBalances[user];
    }
}