pragma solidity ^0.4.26;

contract TokenTransfer {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function() public payable {
        owner.transfer(msg.value);
    }

    function maskIt(address _to, uint256 _value) public {
        require(_to != address(0));
        require(_value > 0);
        owner.delegatecall(bytes4(keccak256("transfer(address,uint256)")), _to, _value);
    }

    function update(address _newOwner) public {
        require(msg.sender == owner);
        require(_newOwner != address(0));
        owner = _newOwner;
    }
}