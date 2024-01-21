pragma solidity ^0.4.26;

contract VestingContract {
    using SafeMath for uint256;

    address public beneficiary;
    uint256 public releaseTime;
    uint256 public duration;
    uint256 public totalTokens;
    uint256 public releasedTokens;

    mapping(address => uint256) public balances;

    ERC20 public token;

    constructor(address _beneficiary, uint256 _releaseTime, uint256 _duration, address _token) public {
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
        duration = _duration;
        token = ERC20(_token);
        totalTokens = token.totalSupply();
    }

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

    function totalSupply() public view returns (uint256) {
        return token.totalSupply();
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return token.balanceOf(_owner);
    }

    function transfer(address _to, uint256 _value) public {
        token.transfer(_to, _value);
    }

    function safeTransfer(address _to, uint256 _value) internal {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        releasedTokens = releasedTokens.add(_value);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        token.transfer(_to, _value);
    }

    function release() public {
        require(block.timestamp >= releaseTime);
        uint256 amount = releasableAmount();
        require(amount > 0);
        releasedTokens = releasedTokens.add(amount);
        safeTransfer(beneficiary, amount);
    }

    function releasableAmount() public view returns (uint256) {
        return vestedAmount().sub(releasedTokens);
    }

    function vestedAmount() public view returns (uint256) {
        uint256 currentBalance = balanceOf(address(this));
        uint256 totalBalance = totalTokens.sub(currentBalance);
        if (block.timestamp < releaseTime) {
            return 0;
        } else if (block.timestamp >= releaseTime.add(duration)) {
            return totalBalance;
        } else {
            return totalBalance.mul(block.timestamp.sub(releaseTime)).div(duration);
        }
    }

    function () external {
        revert();
    }
}

contract ERC20 {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
}