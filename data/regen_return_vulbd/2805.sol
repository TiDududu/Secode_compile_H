pragma solidity ^0.4.26;

contract SafeMath {
    function safeMul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeSub(uint a, uint b) internal pure returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        assert(c >= a && c >= b);
        return c;
    }

    function assert(bool assertion) internal pure {
        require(assertion, "Assertion failed");
    }
}

interface Token {
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function approve(address spender, uint value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract StandardToken is Token, SafeMath {
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    function transfer(address to, uint value) public returns (bool) {
        require(to != address(0), "Invalid address");
        require(value <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] = safeSub(balances[msg.sender], value);
        balances[to] = safeAdd(balances[to], value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns (bool) {
        require(to != address(0), "Invalid address");
        require(value <= balances[from], "Insufficient balance");
        require(value <= allowed[from][msg.sender], "Allowance exceeded");
        balances[from] = safeSub(balances[from], value);
        balances[to] = safeAdd(balances[to], value);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
        emit Transfer(from, to, value);
        return true;
    }

    function balanceOf(address owner) public view returns (uint) {
        return balances[owner];
    }

    function approve(address spender, uint value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint) {
        return allowed[owner][spender];
    }

    function totalSupply() public view returns (uint) {
        revert("Not implemented");
    }
}

contract ReserveToken is StandardToken {
    address public minter;

    constructor() public {
        minter = msg.sender;
    }

    function create(uint amount) public {
        require(msg.sender == minter, "Unauthorized");
        balances[msg.sender] = safeAdd(balances[msg.sender], amount);
    }

    function destroy(uint amount) public {
        require(msg.sender == minter, "Unauthorized");
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] = safeSub(balances[msg.sender], amount);
    }
}

interface AccountLevels {
    function getLevel(address user) external view returns (uint);
}

contract AccountLevelsTest is AccountLevels {
    mapping(address => uint) levels;

    function setLevel(address user, uint level) public {
        levels[user] = level;
    }

    function getLevel(address user) public view returns (uint) {
        return levels[user];
    }
}

contract AZExchange is SafeMath {
    mapping(address => mapping(address => uint)) public tokens;
    mapping(address => bool) public tokenList;
    address public feeAccount;
    uint public feePercent;

    event Deposit(address token, address user, uint amount, uint balance);
    event Withdraw(address token, address user, uint amount, uint balance);
    event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user);
    event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user);

    constructor(address feeAccount_, uint feePercent_) public {
        feeAccount = feeAccount_;
        feePercent = feePercent_;
    }

    function deposit() public payable {
        tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
        emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
    }

    function withdraw(uint amount) public {
        require(tokens[address(0)][msg.sender] >= amount, "Insufficient balance");
        tokens[address(0)][msg.sender] = safeSub(tokens[address(0)][msg.sender], amount);
        require(msg.sender.call.value(amount)(), "Transfer failed");
        emit Withdraw(address(0), msg.sender, amount, tokens[address(0)][msg.sender]);
    }

    function depositToken(address token, uint amount) public {
        require(token != address(0), "Invalid token address");
        require(Token(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
        emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
    }

    function withdrawToken(address token, uint amount) public {
        require(token != address(0), "Invalid token address");
        require(tokens[token][msg.sender] >= amount, "Insufficient balance");
        tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
        require(Token(token).transfer(msg.sender, amount), "Transfer failed");
        emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
    }

    function balanceOf(address token, address user) public view returns (uint) {
        return tokens[token][user];
    }

    function makeOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive) public {
        emit Order(tokenGet, amountGet, tokenGive, amountGive, msg.sender);
    }

    function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive) public {
        emit Cancel(tokenGet, amountGet, tokenGive, amountGive, msg.sender);
    }
}