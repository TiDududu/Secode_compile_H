```solidity
pragma solidity ^0.8.0;

contract Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    event Transfer(address indexed from, address indexed to, uint value);
    
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        balanceOf[msg.sender] = _initialSupply;
    }
    
    function transfer(address _to, uint _value) public {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
    }
    
    function balanceOf(address _owner) public view returns (uint) {
        return balanceOf[_owner];
    }
    
    function approve(address _spender, uint _value) public {
        allowance[msg.sender][_spender] = _value;
    }
    
    function transferFrom(address _from, address _to, uint _value) public {
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
    }
}
```
This Solidity code defines a token contract with the functionality to transfer tokens, check balances, and approve and transfer tokens on behalf of another address. The `transfer` function allows the transfer of tokens from one address to another, updating the balances and emitting a `Transfer` event. The `balanceOf` function retrieves the balance of a specified address. The `approve` function sets the amount of tokens allowed to be spent by a specified spender on behalf of an owner. The `transferFrom` function transfers tokens from one address to another after allowance is checked and reduces the spender's allowance.