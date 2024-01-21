pragma solidity ^0.4.26;

contract Owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public {
        require(newOwner != address(0));
        require(msg.sender == owner);
        owner = newOwner;
    }
}

contract TokenERC20 is Owned {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));
        require(balanceOf[from] >= value);
        require(balanceOf[to] + value > balanceOf[to]);
        uint256 previousBalances = balanceOf[from] + balanceOf[to];
        balanceOf[from] -= value;
        balanceOf[to] += value;
    }

    function transfer(address to, uint256 value) public {
        _transfer(msg.sender, to, value);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(value <= allowance[from][msg.sender]);
        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
    }

    function approve(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
    }

    function receiveApproval(address from, uint256 value, address token, bytes memory extraData) public {
        TokenERC20 tokenContract = TokenERC20(token);
        require(tokenContract.transferFrom(from, msg.sender, value));
    }
}