```solidity
pragma solidity ^0.8.0;

contract Token {
    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply, string memory tokenName, uint8 tokenDecimals, string memory tokenSymbol) {
        owner = msg.sender;
        totalSupply = initialSupply * 10 ** uint256(tokenDecimals);
        name = tokenName;
        symbol = tokenSymbol;
        decimals = tokenDecimals;
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(value <= balanceOf[from], "Insufficient balance");
        require(value <= allowance[from][msg.sender], "Allowance exceeded");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }

    interface tokenRecipient {
        function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
    }

    function approveAndCall(address spender, uint256 value, bytes calldata extraData) public returns (bool success) {
        tokenRecipient spenderContract = tokenRecipient(spender);
        approve(spender, value);
        spenderContract.receiveApproval(msg.sender, value, address(this), extraData);
        return true;
    }

    fallback() external {
        revert("Fallback function not allowed");
    }
}
```