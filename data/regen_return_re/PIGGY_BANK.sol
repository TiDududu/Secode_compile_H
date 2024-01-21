pragma solidity ^0.4.26;

contract Log {
    struct Message {
        address sender;
        uint value;
        bytes data;
    }
    
    Message[] public history;

    function addMessage(address _sender, uint _value, bytes _data) public {
        Message memory newMessage = Message(_sender, _value, _data);
        history.push(newMessage);
    }
}

contract PiggyBank {
    Log public logContract;

    constructor(address _logContract) public {
        logContract = Log(_logContract);
    }

    function put() public payable {
        logContract.addMessage(msg.sender, msg.value, "Deposit");
    }

    function collect(uint _amount) public {
        require(address(this).balance >= _amount, "Insufficient balance");
        msg.sender.transfer(_amount);
        logContract.addMessage(msg.sender, _amount, "Withdrawal");
    }

    function() public payable {
        logContract.addMessage(msg.sender, msg.value, "Fallback deposit");
    }
}