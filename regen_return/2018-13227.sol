```solidity
pragma solidity ^0.8.0;

contract ERC20Token {
    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol,
        uint8 decimalUnits
    ) {
        owner = msg.sender;
        totalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function transfer(address to, uint256 value) public {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        require(balanceOf[to] + value > balanceOf[to], "Overflow detected");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
    }

    function approve(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(to != address(0), "Invalid address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Not enough allowance");
        require(balanceOf[to] + value > balanceOf[to], "Overflow detected");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
    }

    function approveAndCall(address spender, uint256 value, bytes memory extraData) public {
        allowance[msg.sender][spender] = value;
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, value, address(this), extraData);
    }
}

interface ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) external;
}
```