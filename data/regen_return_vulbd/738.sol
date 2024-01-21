pragma solidity ^0.4.26;

contract PermissionedERC223Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimals, address[] distributionAddresses, uint256[] distributionAmounts) public {
        totalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = tokenDecimals;
        owner = msg.sender;

        require(distributionAddresses.length == distributionAmounts.length, "Addresses and amounts count mismatch");

        for (uint i = 0; i < distributionAddresses.length; i++) {
            balanceOf[distributionAddresses[i]] = distributionAmounts[i];
            emit Transfer(address(0), distributionAddresses[i], distributionAmounts[i], "");
        }
    }

    function mint(address to, uint256 value) public onlyOwner {
        totalSupply += value;
        balanceOf[to] += value;
        emit Mint(to, value);
        emit Transfer(address(0), to, value, "");
    }

    function finishMinting() public onlyOwner {
        owner = address(0);
    }

    function burn(uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value, "");
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowance[owner][spender];
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balanceOf[owner];
    }

    function transfer(address to, uint256 value, bytes data) public {
        _transfer(msg.sender, to, value, data);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(value <= allowance[from][msg.sender], "Insufficient allowance");
        allowance[from][msg.sender] -= value;
        _transfer(from, to, value, "");
    }

    function approve(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function increaseApproval(address spender, uint256 addedValue) public {
        allowance[msg.sender][spender] += addedValue;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
    }

    function decreaseApproval(address spender, uint256 subtractedValue) public {
        uint256 oldValue = allowance[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            allowance[msg.sender][spender] = 0;
        } else {
            allowance[msg.sender][spender] -= subtractedValue;
        }
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
    }

    function _transfer(address from, address to, uint256 value, bytes data) internal {
        require(to != address(0), "Invalid transfer destination");
        require(balanceOf[from] >= value, "Insufficient balance");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value, data);
    }
}