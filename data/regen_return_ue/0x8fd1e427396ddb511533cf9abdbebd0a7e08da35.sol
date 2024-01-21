pragma solidity ^0.4.26;

contract TokenBank {
    address public owner;
    address public newOwner;
    uint public minDeposit;
    mapping(address => uint) public tokenBalances;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function changeOwner(address _newOwner) public {
        require(msg.sender == owner);
        newOwner = _newOwner;
    }
    
    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
    
    function WithdrawToken(address _to, uint _amount) public {
        require(msg.sender == owner);
        require(tokenBalances[this] >= _amount);
        tokenBalances[this] -= _amount;
        // Transfer tokens to the specified address
    }
    
    function initTokenBank(uint _minDeposit) public {
        require(msg.sender == owner);
        minDeposit = _minDeposit;
    }
    
    function Deposit() public payable {
        require(msg.value >= minDeposit);
        // Deposit ether into the token bank
    }
    
    function WitdrawTokenToHolder(address _to, uint _amount) public {
        require(msg.sender == owner);
        require(tokenBalances[this] >= _amount);
        tokenBalances[this] -= _amount;
        // Transfer tokens to the specified holder's address
    }
    
    function WithdrawToHolder(address _to, uint _amount) public {
        require(msg.sender == owner);
        require(address(this).balance >= _amount);
        _to.transfer(_amount);
    }
    
    function Bal() public view returns (uint) {
        return address(this).balance;
    }
}