pragma solidity ^0.4.26;

contract VulnerableContract {
    mapping(address => uint) public balances;

    function deposit() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
    }

    function withdraw_step1(uint amount) public {
        require(amount > 0 && amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.call.value(amount)();
    }

    function withdraw_step2(uint amount) internal {
        require(amount > 0 && amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}
