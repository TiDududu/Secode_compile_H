pragma solidity ^0.4.26;

contract Log {
    function AddMessage(address _sender, uint _value, bytes _data) public {}
}

contract ETH_VAULT {
    Log private logContract;
    mapping(address => uint) public balances;

    constructor(address _logContract) public {
        logContract = Log(_logContract);
    }

    function Deposit() public payable {
        require(msg.value >= 1 ether, "Minimum deposit requirement is 1 ether");
        balances[msg.sender] += msg.value;
        logContract.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        logContract.AddMessage(msg.sender, _amount, "Withdrawal");
    }

    function() public payable {
        // Fallback function to receive ether
    }
}