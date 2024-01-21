pragma solidity ^0.4.26;

contract DepositWithdrawContract {
    mapping(address => uint) public balances;
    mapping(address => uint) public lastWithdrawalTime;
    uint public withdrawalLimit = 1 ether;
    uint public withdrawalTimePeriod = 1 weeks;

    function depositFunds() public payable {
        require(msg.value > 0, "Deposit value must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(_amount <= balances[msg.sender], "Insufficient balance");
        require(_amount <= withdrawalLimit, "Exceeds withdrawal limit");
        require(now >= lastWithdrawalTime[msg.sender] + withdrawalTimePeriod, "Withdrawal time period has not passed");

        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
        lastWithdrawalTime[msg.sender] = now;
    }
}