Here is the complete and executable Solidity code based on the provided information:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StandardToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= balances[msg.sender], "Insufficient balance");
        require(to != address(0), "Invalid address");

        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(value <= balances[from], "Insufficient balance");
        require(value <= allowed[from][msg.sender], "Not enough allowance");
        require(to != address(0), "Invalid address");

        balances[from] -= value;
        balances[to] += value;
        allowed[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return allowed[owner][spender];
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function distributeToken(address[] memory recipients, uint256 amount) public {
        require(
            amount * recipients.length <= balances[msg.sender],
            "Insufficient balance"
        );

        for (uint256 i = 0; i < recipients.length; i++) {
            balances[recipients[i]] += amount;
            balances[msg.sender] -= amount;
            emit Transfer(msg.sender, recipients[i], amount);
        }
    }
}
```

This Solidity code creates a StandardToken contract that implements the functionality described, including the totalSupply, balanceOf, transfer, transferFrom, approve, allowance functions, and the distributeToken function. It also includes events for Transfer and Approval. The code includes appropriate checks for input validation and balance verification to ensure the safe operation of the token contract.