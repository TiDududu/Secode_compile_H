pragma solidity ^0.8.0;

contract CERB_Coin {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public icoSupply;
    uint256 public tokenPrice;
    address public owner;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => bool) public frozenAccount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event TransferSell(address indexed from, address indexed to, uint256 value);
    event FrozenFunds(address target, bool frozen);

    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits, uint256 icoTokenSupply, uint256 tokenValue) {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
        icoSupply = icoTokenSupply;
        tokenPrice = tokenValue;
        owner = msg.sender;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(!frozenAccount[msg.sender]);
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Overflow check
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg[msg.sender]][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(!frozenAccount[_from]);
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Overflow check
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }

    function freezeAccount(address target, bool freeze) public {
        require(msg.sender == owner);
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }

    function icoSell(address _to, uint256 _value) public returns (bool success) {
        require(msg.sender == owner);
        require(icoSupply >= _value);
        require(balanceOf[owner] >= _value);
        icoSupply -= _value;
        balanceOf[_to] += _value;
        emit TransferSell(owner, _to, _value);
        return true;
    }
}