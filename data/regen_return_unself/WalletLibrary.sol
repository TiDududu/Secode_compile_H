pragma solidity ^0.4.26;

contract MultiSigWallet {
    address[] public owners;
    uint public required;
    uint public dailyLimit;
    uint public transactionCount;
    mapping (address => bool) public isOwner;
    mapping (bytes32 => Transaction) public transactions;
    mapping (bytes32 => mapping (address => bool)) public confirmations;

    struct Transaction {
        address destination;
        uint value;
        bytes data;
        bool executed;
    }

    event Deposit(address indexed sender, uint value);
    event Submission(bytes32 indexed operation, address indexed destination, uint value, bytes data);
    event Confirmation(address indexed sender, bytes32 indexed operation);
    event Revocation(address indexed sender, bytes32 indexed operation);
    event OwnerAddition(address indexed owner);
    event OwnerRemoval(address indexed owner);
    event RequirementChange(uint required);
    event Execution(bytes32 indexed operation, address indexed destination, uint value, bytes data);
    event ExecutionFailure(bytes32 indexed operation);
    
    modifier onlyOwner {
        require(isOwner[msg.sender]);
        _;
    }

    function revoke(bytes32 _operation) public {
        require(confirmations[_operation][msg.sender]);
        confirmations[_operation][msg.sender] = false;
        emit Revocation(msg.sender, _operation);
    }

    function changeOwner(address _from, address _to) public onlyOwner {
        require(isOwner[_from]);
        isOwner[_from] = false;
        isOwner[_to] = true;
        emit OwnerRemoval(_from);
        emit OwnerAddition(_to);
    }

    function addOwner(address _owner) public onlyOwner {
        isOwner[_owner] = true;
        owners.push(_owner);
        emit OwnerAddition(_owner);
    }

    function removeOwner(address _owner) public onlyOwner {
        require(owners.length > 1);
        isOwner[_owner] = false;
        for (uint i=0; i<owners.length - 1; i++) {
            if (owners[i] == _owner) {
                owners[i] = owners[owners.length - 1];
                break;
            }
        }
        owners.length--;
        emit OwnerRemoval(_owner);
    }

    function changeRequirement(uint _required) public onlyOwner {
        required = _required;
        emit RequirementChange(_required);
    }

    function isOwner(address _addr) public view returns (bool) {
        return isOwner[_addr];
    }

    function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool) {
        return confirmations[_operation][_owner];
    }

    function setDailyLimit(uint _dailyLimit) public onlyOwner {
        dailyLimit = _dailyLimit;
    }

    function execute(address _destination, uint _value, bytes _data) public returns (bytes32) {
        bytes32 operation = keccak256(abi.encodePacked(_destination, _value, _data, block.timestamp));
        require(!transactions[operation].executed && transactionCount < dailyLimit);
        transactions[operation] = Transaction({
            destination: _destination,
            value: _value,
            data: _data,
            executed: false
        });
        transactionCount++;
        emit Submission(operation, _destination, _value, _data);
        return operation;
    }

    function confirm(bytes32 _operation) public onlyOwner {
        require(transactions[_operation].destination != address(0));
        require(!confirmations[_operation][msg.sender]);
        confirmations[_operation][msg.sender] = true;
        emit Confirmation(msg.sender, _operation);
        if (isConfirmed(_operation)) {
            executeTransaction(_operation);
        }
    }

    function isConfirmed(bytes32 _operation) internal view returns (bool) {
        uint count = 0;
        for (uint i=0; i<owners.length; i++) {
            if (confirmations[_operation][owners[i]]) {
                count++;
            }
            if (count == required) {
                return true;
            }
        }
        return false;
    }

    function executeTransaction(bytes32 _operation) internal {
        require(transactions[_operation].executed == false);
        require(isConfirmed(_operation));
        Transaction storage txn = transactions[_operation];
        txn.executed = true;
        if (external_call(txn.destination, txn.value, txn.data.length, txn.data)) {
            emit Execution(_operation, txn.destination, txn.value, txn.data);
        } else {
            emit ExecutionFailure(_operation);
            txn.executed = false;
        }
    }

    function external_call(address destination, uint value, uint dataLength, bytes data) internal returns (bool) {
        bool result;
        assembly {
            let x := mload(0x40)
            let d := add(data, 32)
            result := call(
                sub(gas, 34710),
                destination,
                value,
                d,
                dataLength,
                x,
                0
            )
        }
        return result;
    }
}
