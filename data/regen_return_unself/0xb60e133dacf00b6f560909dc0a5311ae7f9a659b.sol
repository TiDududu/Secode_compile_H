pragma solidity ^0.4.26;

contract Token {
    function totalSupply() public view returns (uint256) {}
    function balanceOf(address _owner) public view returns (uint256) {}
    function transfer(address _to, uint256 _value) public returns (bool) {}
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {}
    function approve(address _spender, uint256 _value) public returns (bool) {}
    function allowance(address _owner, address _spender) public view returns (uint256) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StandardToken is Token {
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
}

contract GymToken is StandardToken {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function() public {
        revert();
    }

    function kill() public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
}