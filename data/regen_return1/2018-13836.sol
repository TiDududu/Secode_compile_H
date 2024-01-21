pragma solidity ^0.4.26;

contract RocketCoin {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event SetupAirDrop(bool status, uint256 amount, uint256 gasPrice);
    event WithdrawFunds(address token, address to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    constructor(uint256 _initialSupply) public {
        name = "Rocket Coin";
        symbol = "RCKT";
        decimals = 18;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balanceOf[_owner];
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowance[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function multiTransfer(address[] _recipients, uint256[] _values) public returns (bool success) {
        require(_recipients.length == _values.length, "Array lengths do not match");
        uint256 total = 0;
        for (uint256 i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0), "Invalid address");
            require(balanceOf[msg.sender] >= _values[i], "Insufficient balance");
            balanceOf[msg.sender] -= _values[i];
            balanceOf[_recipients[i]] += _values[i];
            emit Transfer(msg.sender, _recipients[i], _values[i]);
            total += _values[i];
        }
        require(total > 0, "Total transfer amount must be greater than 0");
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function setupAirDrop(bool _status, uint256 _amount, uint256 _gasPrice) public onlyOwner {
        emit SetupAirDrop(_status, _amount, _gasPrice);
    }

    function withdrawFunds(address _token, address _to, uint256 _amount) public onlyOwner {
        if (_token == address(0)) {
            require(address(this).balance >= _amount, "Insufficient contract balance");
            _to.transfer(_amount);
        } else {
            require(ERC20(_token).balanceOf(address(this)) >= _amount, "Insufficient contract balance");
            require(ERC20(_token).transfer(_to, _amount), "Token transfer failed");
        }
        emit WithdrawFunds(_token, _to, _amount);
    }

    function () public payable {
        // Fallback function for airdrops
    }
}

interface ERC20 {
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}
