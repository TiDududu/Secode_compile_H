pragma solidity ^0.4.26;

library SafeMath {
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
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Subtraction overflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Addition overflow");
        return c;
    }
}

interface ERC20Basic {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}

interface ERC20 is ERC20Basic {
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

library SafeERC20 {
    function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
        require(token.transfer(to, value), "Safe transfer failed");
    }

    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
        require(token.transferFrom(from, to, value), "Safe transfer from failed");
    }

    function safeApprove(ERC20 token, address spender, uint256 value) internal {
        require(token.approve(spender, value), "Safe approve failed");
    }
}

contract Ownable {
    address public owner;

    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(owner);
        owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Invalid owner address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract DVPlock is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    ERC20 public token;
    uint256 public releaseTime;

    struct Investor {
        uint256 lockedTokens;
        uint256 releaseTime;
    }

    mapping(address => Investor) public investors;
    mapping(address => uint256) public sponsors;

    event TokenSet(address indexed tokenAddress);
    event ReleaseTimeSet(uint256 releaseTime);
    event SponsorAdded(address indexed sponsor, uint256 tokensAllocated);
    event InvestorAdded(address indexed investor, uint256 tokensAllocated);
    event TokensReleased(address indexed recipient, uint256 tokensReleased);

    function setToken(address _token) public onlyOwner {
        require(_token != address(0), "Invalid token address");
        token = ERC20(_token);
        emit TokenSet(_token);
    }

    function setReleaseTime(uint256 _releaseTime) public onlyOwner {
        releaseTime = _releaseTime;
        emit ReleaseTimeSet(_releaseTime);
    }

    function addSponsor(address _sponsor, uint256 _tokens) public onlyOwner {
        require(_sponsor != address(0), "Invalid sponsor address");
        sponsors[_sponsor] = _tokens;
        emit SponsorAdded(_sponsor, _tokens);
    }

    function addInvestor(address _investor, uint256 _tokens, uint256 _lockPeriod) public onlyOwner {
        require(_investor != address(0), "Invalid investor address");
        require(_lockPeriod > 0, "Invalid lock period");
        investors[_investor] = Investor(_tokens, now.add(_lockPeriod));
        emit InvestorAdded(_investor, _tokens);
    }

    function release() public {
        require(now >= releaseTime, "Tokens are not yet released");
        if (sponsors[msg.sender] > 0) {
            uint256 sponsorTokens = sponsors[msg.sender];
            sponsors[msg.sender] = 0;
            token.safeTransfer(msg.sender, sponsorTokens);
            emit TokensReleased(msg.sender, sponsorTokens);
        } else {
            Investor storage investor = investors[msg.sender];
            require(investor.releaseTime <= now, "Tokens are not yet released for the investor");
            uint256 lockedTokens = investor.lockedTokens;
            investor.lockedTokens = 0;
            token.safeTransfer(msg.sender, lockedTokens);
            emit TokensReleased(msg.sender, lockedTokens);
        }
    }
}