pragma solidity ^0.4.26;

contract Log {
    function AddMessage(address _sender, string _data, uint _value, uint _time) public {}
}

contract TimeLock {
    address public logFile;
    uint public minSum;
    bool public initialized;

    function SetMinSum(uint _minSum) public {
        minSum = _minSum;
    }

    function SetLogFile(address _logFile) public {
        logFile = _logFile;
    }

    function Initialized() public {
        initialized = true;
    }

    function Put(uint _timeLock) public payable {
        require(msg.value >= minSum);
        if (_timeLock > 0) {
            Log(logFile).AddMessage(msg.sender, "Funds deposited with time lock", msg.value, now + _timeLock);
        } else {
            Log(logFile).AddMessage(msg.sender, "Funds deposited", msg.value, now);
        }
    }

    function Collect() public {
        require(this.balance >= minSum);
        Log(logFile).AddMessage(msg.sender, "Funds collected", this.balance, now);
        msg.sender.transfer(this.balance);
    }

    function () public payable {
        Log(logFile).AddMessage(msg.sender, "Funds deposited with no time lock", msg.value, now);
    }
}