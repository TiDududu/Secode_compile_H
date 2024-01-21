pragma solidity ^0.4.26;

contract StandardToken {
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    uint256 public totalSupply;

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        require(balanceOf[_to] + _value >= balanceOf[_to]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        return true;
    }
}

contract ExtendedToken is StandardToken {
    function batchTransfer(address[] _receivers, uint256 _value) public returns (bool) {
        uint256 cnt = _receivers.length;
        uint256 amount = uint256(cnt) * _value;
        require(cnt > 0 && cnt <= 20);
        require(_value > 0 && balanceOf[msg.sender] >= amount);

        balanceOf[msg.sender] -= amount;
        for (uint i = 0; i < cnt; i++) {
            balanceOf[_receivers[i]] += _value;
            Transfer(msg.sender, _receivers[i], _value);
        }
        return true;
    }
}

contract Traded is ExtendedToken {
    address public manager;

    modifier onlyManager {
        require(msg.sender == manager);
        _;
    }

    function trade(address _from, address _to, uint256 _price) public onlyManager {
        require(balanceOf[_from] >= _price);
        balanceOf[_from] -= _price;
        balanceOf[_to] += _price;
    }
}

contract Shark is Traded {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public tokenPrice;
    address public owner;

    modifier onlyHuman {
        require(msg.sender == tx.origin);
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function Shark(string _tokenName, string _tokenSymbol, uint256 _totalSupply) public {
        name = _tokenName;
        symbol = _tokenSymbol;
        decimals = 18;
        totalSupply = _totalSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function changeTokenPrice(uint256 _newPrice) public onlyOwner {
        tokenPrice = _newPrice;
    }

    function buyTokens(uint256 _amount) public payable onlyHuman {
        require(msg.value == _amount * tokenPrice);
        balanceOf[msg.sender] += _amount;
        balanceOf[owner] -= _amount;
        Transfer(owner, msg.sender, _amount);
    }

    function sellTokens(uint256 _amount) public onlyHuman {
        require(balanceOf[msg.sender] >= _amount);
        balanceOf[owner] += _amount;
        balanceOf[msg.sender] -= _amount;
        msg.sender.transfer(_amount * tokenPrice);
        Transfer(msg.sender, owner, _amount);
    }

    function airdropTokens(address[] _recipients, uint256 _value) public onlyOwner {
        batchTransfer(_recipients, _value);
    }

    function cashOut(uint256 _amount) public onlyOwner {
        owner.transfer(_amount);
    }
}