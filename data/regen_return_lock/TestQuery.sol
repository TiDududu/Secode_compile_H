pragma solidity ^0.4.26;

contract TransferLock {
    struct Transfer {
        address owner;
        uint amount;
    }
    
    mapping(uint => Transfer) transfers;
    mapping(address => uint) nonces;

    function lockforTransfer(uint _amount) public payable {
        require(msg.value == _amount);
        uint transferId = nonces[msg.sender]++;
        transfers[transferId] = Transfer(msg.sender, _amount);
    }

    function getTransfer(uint _transferId) public view returns (address, uint) {
        Transfer memory transfer = transfers[_transferId];
        return (transfer.owner, transfer.amount);
    }
}