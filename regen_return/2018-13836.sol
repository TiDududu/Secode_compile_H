```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RocketCoin {
    string public name = "Rocket Coin";
    string public symbol = "RC";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event MultiTransfer(address indexed from, address[] to, uint256[] value);
    event AirDropSetup(address indexed owner, uint256 totalAmount, uint256 numRecipients);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function balanceOf(address _address) public view returns (uint256) {
        return balanceOf[_address];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowance[_owner][_spender];
    }

    function multiTransfer(address[] calldata _to, uint256[] calldata _values) public returns (bool) {
        require(_to.length == _values.length, "Arrays length mismatch");
        uint256 totalValue = 0;

        for (uint256 i = 0; i < _to.length; i++) {
            require(_to[i] != address(0), "Invalid address");
            totalValue += _values[i];
        }
        require(balanceOf[msg.sender] >= totalValue, "Insufficient balance");
        
        for (uint256 i = 0; i < _to.length; i++) {
            balanceOf[msg.sender] -= _values[i];
            balanceOf[_to[i]] += _values[i];
            emit Transfer(msg.sender, _to[i], _values[i]);
        }
        emit MultiTransfer(msg.sender, _to, _values);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Invalid address");
        require(_value <= allowance[_from][msg.sender], "Insufficient allowance");
        require(balanceOf[_from] >= _value, "Insufficient balance");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0), "Invalid address");

        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function setupAirDrop(uint256 _totalAmount, uint256 _numRecipients) public {
        require(msg.sender == owner, "Only owner can set up airdrop");

        // Add logic for setting up airdrop
        // ...

        emit AirDropSetup(owner, _totalAmount, _numRecipients);
    }
}
```