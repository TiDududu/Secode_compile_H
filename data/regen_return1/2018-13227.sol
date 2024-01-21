pragma solidity ^0.4.26;

interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
}

contract owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner);
        owner = newOwner;
    }
}

contract token is owned {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) public {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
    }

    function transfer(address _to, uint256 _value) public {
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(_to != address(0));
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
    }

    function () public {
        revert();
    }
}

contract MoneyChainNetToken is token {
    uint public sellPrice;
    uint public buyPrice;
    mapping (address => bool) public frozenAccount;

    event FrozenFunds(address target, bool frozen);

    constructor(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) token(initialSupply, tokenName, decimalUnits, tokenSymbol) public {}

    function setPrices(uint newSellPrice, uint newBuyPrice) public {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    function freezeAccount(address target, bool freeze) public {
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }
}