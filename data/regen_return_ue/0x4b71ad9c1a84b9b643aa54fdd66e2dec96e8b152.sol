pragma solidity ^0.4.26;

contract Token {
    mapping(address => uint) public balances;
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function transfer(address _to, uint _value) public returns (bool) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        require(balances[_from] >= _value);
        require(_value <= allowed[_from][msg.sender]);
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        return true;
    }
    
    mapping(address => mapping(address => uint)) public allowed;
    
    function transferToMultiple(address _contractAddress, address[] _recipients, uint _amount) public returns (bool) {
        require(_contractAddress != address(0));
        require(_recipients.length > 0);
        require(_amount > 0);
        
        for (uint i = 0; i < _recipients.length; i++) {
            require(transferFrom(_contractAddress, _recipients[i], _amount));
        }
        
        return true;
    }
}