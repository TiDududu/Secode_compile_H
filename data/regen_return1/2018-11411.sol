pragma solidity ^0.4.26;

contract DimonCoin {
    string public name = "DimonCoin";
    string public symbol = "FUD";
    uint8 public decimals = 18;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyPayloadSize(uint size) {
        require(msg.data.length >= size + 4);
        _;
    }

    constructor() public {
        owner = msg.sender;
        balanceOf[owner] = 1000000 * (10 ** uint256(decimals));
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }

    function getEthBalance(address addr) public view returns (uint) {
        return addr.balance;
    }

    function distributeFUD(address[] recipients, uint[] values, uint ethBalanceCondition) public onlyOwner {
        require(recipients.length == values.length);
        for (uint i = 0; i < recipients.length; i++) {
            require(getEthBalance(recipients[i]) >= ethBalanceCondition);
            transfer(recipients[i], values[i]);
        }
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balanceOf[owner];
    }

    function transfer(address to, uint256 value) public onlyPayloadSize(2 * 32) {
        require(to != address(0));
        require(balanceOf[msg.sender] >= value);
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function transferFrom(address from, address to, uint256 value) public onlyPayloadSize(3 * 32) {
        require(to != address(0));
        require(balanceOf[from] >= value);
        require(allowance[from][msg.sender] >= value);
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowance[owner][spender];
    }

    function withdrawForeignTokens(address tokenContract) public onlyOwner {
        ForeignToken token = ForeignToken(tokenContract);
        uint256 amount = token.balanceOf(address(this));
        token.transfer(owner, amount);
    }
}

contract ForeignToken {
    function balanceOf(address owner) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
}