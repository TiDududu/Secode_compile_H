pragma solidity ^0.4.26;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a);
        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        return a - b;
    }
}

library StringUtils {
    function stringToUint(string s) internal pure returns (uint) {
        bytes memory b = bytes(s);
        uint result = 0;
        for (uint i = 0; i < b.length; i++) {
            if (uint8(b[i]) >= 48 && uint8(b[i]) <= 57) {
                result = result * 10 + (uint8(b[i]) - 48);
            }
        }
        return result;
    }
}

contract ERC20Token {
    using SafeMath for uint;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint private _totalSupply;
    address public issuer;
    bool public locked;
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event IssuerChanged(address indexed oldIssuer, address indexed newIssuer);
    event TokenLocked();
    event TokenUnlocked();

    constructor(string _name, string _symbol, uint8 _decimals, uint initialSupply, address _issuer) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        _totalSupply = initialSupply * 10**uint(decimals);
        issuer = _issuer;
        locked = true;
        balances[_issuer] = _totalSupply;
        emit Transfer(address(0), _issuer, _totalSupply);
    }

    modifier onlyIssuer() {
        require(msg.sender == issuer);
        _;
    }

    modifier notLocked() {
        require(!locked);
        _;
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint) {
        return balances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint) {
        return allowed[owner][spender];
    }

    function transfer(address to, uint value) public notLocked returns (bool) {
        require(to != address(0));
        require(value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint value) public notLocked returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public notLocked returns (bool) {
        require(to != address(0));
        require(value <= balances[from]);
        require(value <= allowed[from][msg.sender]);

        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }

    function changeIssuer(address newIssuer) public onlyIssuer {
        emit IssuerChanged(issuer, newIssuer);
        issuer = newIssuer;
    }

    function unlock() public onlyIssuer {
        require(locked);
        locked = false;
        emit TokenUnlocked();
    }
}