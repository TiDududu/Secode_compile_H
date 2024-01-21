pragma solidity ^0.8.0;

contract ERC20Token {
    string public name = "ERC20 Token";
    string public symbol = "ERC";
    uint8 public decimals = 18;
    uint public totalSupply;
    address public owner;
    bool public locked;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event LockSet(bool locked);

    constructor(uint _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint(decimals);
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
        locked = false;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier notLocked {
        require(!locked, "Contract is locked");
        _;
    }

    function safeMul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        require(a == 0 || c / a == b, "Multiplication overflow");
        return c;
    }

    function safeDiv(uint a, uint b) internal pure returns (uint) {
        require(b > 0, "Division by zero");
        uint c = a / b;
        return c;
    }

    function safeSub(uint a, uint b) internal pure returns (uint) {
        require(b <= a, "Subtraction overflow");
        uint c = a - b;
        return c;
    }

    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a && c >= b, "Addition overflow");
        return c;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setLock(bool _locked) public onlyOwner {
        locked = _locked;
        emit LockSet(locked);
    }

    function transfer(address to, uint value) public notLocked {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], value);
        balanceOf[to] = safeAdd(balanceOf[to], value);
        
        emit Transfer(msg.sender, to, value);
    }

    function transferFrom(address from, address to, uint value) public notLocked {
        require(to != address(0), "Invalid address");
        require(value <= allowance[from][msg.sender], "Insufficient allowance");
        require(value <= balanceOf[from], "Insufficient balance");
        
        balanceOf[from] = safeSub(balanceOf[from], value);
        balanceOf[to] = safeAdd(balanceOf[to], value);
        allowance[from][msg.sender] = safeSub(allowance[from][msg.sender], value);
        
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) public notLocked {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function burn(uint value) public onlyOwner {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], value);
        totalSupply = safeSub(totalSupply, value);
        
        emit Transfer(msg.sender, address(0), value);
    }

    function burnFrom(address from, uint value) public notLocked {
        require(value <= allowance[from][msg.sender], "Insufficient allowance");
        require(value <= balanceOf[from], "Insufficient balance");
        
        balanceOf[from] = safeSub(balanceOf[from], value);
        totalSupply = safeSub(totalSupply, value);
        allowance[from][msg.sender] = safeSub(allowance[from][msg.sender], value);
        
        emit Transfer(from, address(0), value);
    }
}