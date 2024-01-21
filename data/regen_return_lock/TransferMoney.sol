pragma solidity ^0.4.26;

contract MoneyContract {
    mapping(address => uint) public balances;

    function contractMoneyBalance() public view returns (uint) {
        return address(this).balance;
    }

    function addressMoneyBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    function depositMoney() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
    }
}