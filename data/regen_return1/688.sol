pragma solidity ^0.4.26;

contract SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}

contract QPay is SafeMath {
    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public distributionStartTime;
    uint256 public distributionEndTime;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    bool public distributionStatus;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function() public payable {
        require(distributionStatus && now >= distributionStartTime && now <= distributionEndTime);
        uint256 tokens = msg.value; // Calculate tokens based on Ether sent
        balanceOf[msg.sender] = add(balanceOf[msg.sender], tokens);
        balanceOf[owner] = sub(balanceOf[owner], tokens);
        emit Transfer(owner, msg.sender, tokens);
    }

    function setupQPY(string _tokenName, string _tokenSymbol, uint8 _tokenDecimals, uint256 _initialSupply, uint256 _startTime, uint256 _endTime, address[] _receivers, uint256[] _amounts) public onlyOwner {
        require(!distributionStatus);
        name = _tokenName;
        symbol = _tokenSymbol;
        decimals = _tokenDecimals;
        totalSupply = _initialSupply;
        distributionStartTime = _startTime;
        distributionEndTime = _endTime;
        for (uint i = 0; i < _receivers.length; i++) {
            balanceOf[_receivers[i]] = _amounts[i];
            emit Transfer(owner, _receivers[i], _amounts[i]);
        }
        distributionStatus = true;
    }
}