pragma solidity ^0.4.26;

contract PiggyBank {
    address public creator;
    uint public minimumSum;
    mapping(address => uint) public balances;

    constructor(uint _minimumSum) public {
        creator = msg.sender;
        minimumSum = _minimumSum;
    }

    function() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
    }

    function collect(uint _amount) public {
        require(balances[msg.sender] >= minimumSum);
        require(_amount <= balances[msg.sender]);
        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
    }

    function breakContract() public {
        require(msg.sender == creator);
        require(address(this).balance >= minimumSum);
        selfdestruct(creator);
    }
}