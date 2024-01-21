pragma solidity ^0.4.26;

contract MultiSigWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;
    
    struct Transaction {
        address destination;
        uint value;
        bytes data;
        bool executed;
        mapping(address => bool) isConfirmed;
    }
    
    Transaction[] public transactions;
    
    event Deposit(address indexed sender, uint value);
    event Submission(uint indexed transactionId);
    event Confirmation(address indexed sender, uint indexed transactionId);
    event Revocation(address indexed sender, uint indexed transactionId);
    event Execution(uint indexed transactionId);
    event ExecutionFailure(uint indexed transactionId);
    event OwnerAddition(address indexed owner);
    event OwnerRemoval(address indexed owner);
    event RequirementChange(uint required);
    
    modifier onlyOwner {
        require(isOwner[msg.sender]);
        _;
    }
    
    modifier transactionExists(uint transactionId) {
        require(transactionId < transactions.length);
        _;
    }
    
    modifier confirmed(uint transactionId, address owner) {
        require(transactions[transactionId].isConfirmed[owner]);
        _;
    }
    
    modifier notConfirmed(uint transactionId, address owner) {
        require(!transactions[transactionId].isConfirmed[owner]);
        _;
    }
    
    constructor(address[] memory _owners, uint _required) public {
        require(_owners.length > 0 && _required > 0 && _required <= _owners.length);
        for (uint i=0; i<_owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0) && !isOwner[owner]);
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }
    
    function addOwner(address owner) public onlyOwner {
        require(owner != address(0) && !isOwner[owner]);
        isOwner[owner] = true;
        owners.push(owner);
        emit OwnerAddition(owner);
    }
    
    function removeOwner(address owner) public onlyOwner {
        require(isOwner[owner]);
        isOwner[owner] = false;
        for (uint i=0; i<owners.length; i++) {
            if (owners[i] == owner) {
                owners[i] = owners[owners.length - 1];
                break;
            }
        }
        owners.length--;
        emit OwnerRemoval(owner);
    }
    
    function changeRequirement(uint _required) public onlyOwner {
        require(_required > 0 && _required <= owners.length);
        required = _required;
        emit RequirementChange(_required);
    }
    
    function submitTransaction(address destination, uint value, bytes data) public onlyOwner {
        uint transactionId = transactions.length;
        transactions.push(Transaction({
            destination: destination,
            value: value,
            data: data,
            executed: false
        }));
        emit Submission(transactionId);
    }
    
    function confirmTransaction(uint transactionId) public onlyOwner transactionExists(transactionId) notConfirmed(transactionId, msg.sender) {
        transactions[transactionId].isConfirmed[msg.sender] = true;
        emit Confirmation(msg.sender, transactionId);
    }
    
    function revokeConfirmation(uint transactionId) public onlyOwner transactionExists(transactionId) confirmed(transactionId, msg.sender) {
        transactions[transactionId].isConfirmed[msg.sender] = false;
        emit Revocation(msg.sender, transactionId);
    }
    
    function executeTransaction(uint transactionId) public onlyOwner transactionExists(transactionId) {
        Transaction storage transaction = transactions[transactionId];
        require(getConfirmationCount(transactionId) >= required && !transaction.executed);
        transaction.executed = true;
        if (external_call(transaction.destination, transaction.value, transaction.data.length, transaction.data)) {
            emit Execution(transactionId);
        } else {
            emit ExecutionFailure(transactionId);
            transaction.executed = false;
        }
    }
    
    function getConfirmationCount(uint transactionId) public view returns (uint count) {
        for (uint i=0; i<owners.length; i++) {
            if (transactions[transactionId].isConfirmed[owners[i]]) {
                count++;
            }
        }
    }
    
    function getTransactionCount() public view returns (uint count) {
        return transactions.length;
    }
    
    function getOwners() public view returns (address[] memory) {
        return owners;
    }
    
    function getConfirmations(uint transactionId) public view returns (address[] memory _confirmations) {
        address[] memory confirmations = new address[](owners.length);
        uint count = 0;
        for (uint i=0; i<owners.length; i++) {
            if (transactions[transactionId].isConfirmed[owners[i]]) {
                confirmations[count] = owners[i];
                count++;
            }
        }
        _confirmations = new address[](count);
        for (uint j=0; j<count; j++) {
            _confirmations[j] = confirmations[j];
        }
    }
    
    function isConfirmed(uint transactionId) public view returns (bool) {
        return getConfirmationCount(transactionId) >= required;
    }
    
    function isOwner(address owner) public view returns (bool) {
        return isOwner[owner];
    }
    
    function getTransactionIds() public view returns (uint[] memory _transactionIds) {
        uint[] memory transactionIds = new uint[](transactions.length);
        for (uint i=0; i<transactions.length; i++) {
            transactionIds[i] = i;
        }
        _transactionIds = transactionIds;
    }
    
    function getTransactionById(uint transactionId) public view returns (address destination, uint value, bytes memory data, bool executed) {
        Transaction memory transaction = transactions[transactionId];
        return (transaction.destination, transaction.value, transaction.data, transaction.executed);
    }
    
    function external_call(address destination, uint value, uint dataLength, bytes data) internal returns (bool) {
        bool result;
        assembly {
            let x := mload(0x40)
            let d := add(data, 32)
            result := call(gas, destination, value, d, dataLength, x, 0)
        }
        return result;
    }
}