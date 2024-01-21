pragma solidity ^0.4.26;

contract SnooKarma {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    address public oracle;
    address public maintainer;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(string => uint256) public redeemedKarma;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event OracleChanged(address indexed previousOracle, address indexed newOracle);
    event OracleRemoved(address indexed previousOracle);
    event MaintainerChanged(address indexed previousMaintainer, address indexed newMaintainer);
    event KarmaRedeemed(string username, uint256 amount);

    constructor(
        string tokenName,
        string tokenSymbol,
        uint8 tokenDecimals,
        uint256 initialSupply
    ) public {
        name = tokenName;
        symbol = tokenSymbol;
        decimals = tokenDecimals;
        totalSupply = initialSupply * 10 ** uint256(tokenDecimals);
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        oracle = address(0);
        maintainer = address(0);
    }

    function transfer(address to, uint256 value) public {
        require(to != address(0));
        require(value <= balanceOf[msg.sender]);
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(to != address(0));
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a + b >= a);
        return a + b;
    }

    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }

    function transferOwnership(address newOwner) public onlyBy(owner) {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function changeOracle(address newOracle) public onlyBy(owner) {
        emit OracleChanged(oracle, newOracle);
        oracle = newOracle;
    }

    function removeOracle() public onlyBy(owner) {
        emit OracleRemoved(oracle);
        oracle = address(0);
    }

    function changeMaintainer(address newMaintainer) public onlyBy(owner) {
        emit MaintainerChanged(maintainer, newMaintainer);
        maintainer = newMaintainer;
    }

    function redeem(
        string username,
        uint256 amount,
        bytes memory signature
    ) public {
        // Verify signature and update balances
        // Implementation details omitted for brevity
        redeemedKarma[username] += amount;
        emit KarmaRedeemed(username, amount);
    }

    function redeemedKarmaOf(string username) public view returns (uint256) {
        return redeemedKarma[username];
    }
}