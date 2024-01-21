```solidity
pragma solidity ^0.8.0;

contract TokenERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals) {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = tokenDecimals;
    }

    function transferOwnership(address newOwner) public {
        require(newOwner != address(0), "Invalid address");
        balanceOf[newOwner] = balanceOf[address(this)];
        balanceOf[address(this)] = 0;
    }

    function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external {
        require(token == address(this), "Invalid token");
        require(tokens > 0, "Invalid amount");
        _transfer(from, msg.sender, tokens);
    }

    function transfer(address to, uint256 tokens) public {
        _transfer(msg.sender, to, tokens);
    }
    
    function transferFrom(address from, address to, uint256 tokens) public {
        require(tokens <= allowance[from][msg.sender], "Allowance exceeded");
        allowance[from][msg.sender] -= tokens;
        _transfer(from, to, tokens);
    }

    function _transfer(address from, address to, uint256 tokens) internal {
        require(to != address(0), "Invalid address");
        require(balanceOf[from] >= tokens, "Insufficient balance");
        require(balanceOf[to] + tokens > balanceOf[to], "Overflow error");

        uint256 previousBalance = balanceOf[from] + balanceOf[to];
        balanceOf[from] -= tokens;
        balanceOf[to] += tokens;
        emit Transfer(from, to, tokens);
        assert(balanceOf[from] + balanceOf[to] == previousBalance);
    }
}
```