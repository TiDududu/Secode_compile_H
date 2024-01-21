```solidity
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address owner) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

contract ERC20Token is IERC20 {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000 * 10**uint256(decimals);
    
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;
    
    constructor() {
        balances[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        require(to != address(0), "Invalid address");
        require(balances[msg.sender] >= value, "Insufficient balance");
        
        balances[msg.sender] -= value;
        balances[to] += value;
        
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function balanceOf(address owner) public view override returns (uint256) {
        return balances[owner];
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        require(to != address(0), "Invalid address");
        require(balances[from] >= value, "Insufficient balance");
        require(allowances[from][msg.sender] >= value, "Insufficient allowance");
        
        balances[from] -= value;
        balances[to] += value;
        allowances[from][msg.sender] -= value;
        
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public override returns (bool) {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
```