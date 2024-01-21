pragma solidity ^0.4.26;

contract ICOPlatform {
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    modifier onlyWhileOpen() {
        require(now < closingTime, "Crowdsale is closed");
        _;
    }

    modifier onlyWhileClosed() {
        require(now >= closingTime, "Crowdsale is still open");
        _;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balanceOf[_owner];
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowance[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public onlyWhileOpen {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }

    function approve(address _spender, uint256 _value) public onlyWhileOpen {
        allowance[msg.sender][_spender] = _value;
    }

    function transferFrom(address _from, address _to, uint256 _value) public onlyWhileOpen {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "Multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "Division by zero");
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Subtraction underflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Addition overflow");
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "Modulo by zero");
        return a % b;
    }

    function renounceOwnership() public onlyOwner {
        owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }

    event CommissionWalletUpdated(address indexed oldCommissionWallet, address indexed newCommissionWallet);
    event CrowdsaleCreated(address indexed crowdsale, uint256 cap, uint256 goal, uint256 rate, uint256 minInvest, uint256 closingTime, address commissionWallet);
}