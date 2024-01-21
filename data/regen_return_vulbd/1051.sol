pragma solidity ^0.4.26;

contract MyToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    address public authority;
    bool public stopped;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event AuthorityChanged(address indexed previousAuthority, address indexed newAuthority);
    event Stopped();
    event Started();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner is allowed to call this function");
        _;
    }

    modifier onlyAuthorized() {
        require(msg.sender == owner || msg.sender == authority, "Caller is not authorized");
        _;
    }

    modifier whenNotStopped() {
        require(!stopped, "Contract is stopped");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**uint256(_decimals);
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        stopped = false;
    }

    function setOwner(address newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setAuthority(address newAuthority) public onlyOwner {
        emit AuthorityChanged(authority, newAuthority);
        authority = newAuthority;
    }

    function isAuthorized(address caller) public view returns (bool) {
        return (caller == owner || caller == authority);
    }

    function stop() public onlyOwner {
        stopped = true;
        emit Stopped();
    }

    function start() public onlyOwner {
        stopped = false;
        emit Started();
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balanceOf[account];
    }

    function transfer(address to, uint256 value) public whenNotStopped {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value <= balanceOf[msg.sender], "ERC20: transfer amount exceeds balance");
        
        balanceOf[msg.sender] = sub(balanceOf[msg.sender], value);
        balanceOf[to] = add(balanceOf[to], value);
        emit Transfer(msg.sender, to, value);
    }

    function transferFrom(address from, address to, uint256 value) public whenNotStopped {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value <= balanceOf[from], "ERC20: transfer amount exceeds balance");
        require(value <= allowance[from][msg.sender], "ERC20: transfer amount exceeds allowance");
        
        balanceOf[from] = sub(balanceOf[from], value);
        balanceOf[to] = add(balanceOf[to], value);
        allowance[from][msg.sender] = sub(allowance[from][msg.sender], value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint256 value) public whenNotStopped {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowance[owner][spender];
    }
}