pragma solidity ^0.4.26;

interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256);
    function transfer(address to, uint256 tokens) external returns (bool);
    function transferFrom(address from, address to, uint256 tokens) external returns (bool);
}

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
        require(b <= a, "Subtraction underflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Addition overflow");
        return c;
    }
}

contract TwoYearDreamTokensVesting {
    using SafeMath for uint256;

    ERC20 public token;
    address public owner;

    struct VestingSchedule {
        uint256 startTimestamp;
        uint256[] unlockTimestamps;
        uint256[] unlockPercentages;
    }

    mapping(address => address) public withdrawalAddress;
    mapping(address => VestingSchedule) public vestingSchedules;

    constructor(ERC20 _token) public {
        token = _token;
        owner = msg.sender;
    }

    function initializeVestingFor(address account, address withdrawAddress, uint256 startTimestamp) public {
        require(msg.sender == owner, "Only owner can initialize vesting");
        withdrawalAddress[account] = withdrawAddress;
        vestingSchedules[account].startTimestamp = startTimestamp;
    }

    function getAvailableTokensToWithdraw(address account) public view returns (uint256) {
        VestingSchedule storage vestingSchedule = vestingSchedules[account];
        uint256 availableTokens = 0;
        for (uint256 i = 0; i < vestingSchedule.unlockTimestamps.length; i++) {
            if (now >= vestingSchedule.unlockTimestamps[i]) {
                availableTokens = availableTokens.add(token.balanceOf(address(this)).mul(vestingSchedule.unlockPercentages[i]).div(100));
            }
        }
        return availableTokens;
    }

    function vestingRules(address account, uint256[] memory _unlockTimestamps, uint256[] memory _unlockPercentages) public {
        require(msg.sender == owner, "Only owner can set vesting rules");
        vestingSchedules[account].unlockTimestamps = _unlockTimestamps;
        vestingSchedules[account].unlockPercentages = _unlockPercentages;
    }

    function withdrawTokens() public {
        uint256 availableTokens = getAvailableTokensToWithdraw(msg.sender);
        require(availableTokens > 0, "No tokens available for withdrawal");
        token.transfer(withdrawalAddress[msg.sender], availableTokens);
    }

    function sendTokens(address to, uint256 tokens) public {
        token.transfer(to, tokens);
    }

    function getTokensAmountAllowedToWithdraw(address account) public view returns (uint256) {
        VestingSchedule storage vestingSchedule = vestingSchedules[account];
        uint256 allowedTokens = 0;
        for (uint256 i = 0; i < vestingSchedule.unlockTimestamps.length; i++) {
            if (now >= vestingSchedule.unlockTimestamps[i]) {
                allowedTokens = allowedTokens.add(token.balanceOf(address(this)).mul(vestingSchedule.unlockPercentages[i]).div(100));
            }
        }
        return allowedTokens;
    }
}