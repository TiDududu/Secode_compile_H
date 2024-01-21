pragma solidity ^0.4.26;

contract Splitter {
    address public ethAddress;
    address public etcAddress;
    address public oracleAddress;
    uint public fee;

    constructor(address _ethAddress, address _etcAddress, address _oracleAddress, uint _fee) public {
        ethAddress = _ethAddress;
        etcAddress = _etcAddress;
        oracleAddress = _oracleAddress;
        fee = _fee;
    }

    function split() public payable {
        require(msg.value > 0, "Value must be greater than 0");
        if (AmIOnTheFork()) {
            ethAddress.transfer(msg.value);
        } else {
            uint etcAmount = msg.value - fee;
            etcAddress.transfer(etcAmount);
        }
    }

    function() public {
        revert("Deposits to this contract are not allowed");
    }

    function AmIOnTheFork() public view returns (bool) {
        Oracle oracle = Oracle(oracleAddress);
        return oracle.isOnFork();
    }
}

contract Oracle {
    function isOnFork() public view returns (bool);
}