pragma solidity ^0.4.26;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

interface ERC20 {
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}

interface WhiteList {
    function isPaidUntil(address _addr, uint256 _time) external view returns (bool);
}

contract PresalePool {
    using SafeMath for uint256;

    ERC20 public token;
    WhiteList public whiteList;
    address public owner;
    uint256 public presaleEndTime;
    mapping(address => uint256) public deposits;

    constructor(address _token, address _whiteList, uint256 _presaleEndTime) public {
        token = ERC20(_token);
        whiteList = WhiteList(_whiteList);
        owner = msg.sender;
        presaleEndTime = _presaleEndTime;
    }

    function () external payable {
        _ethDeposit();
    }

    function balanceOf(address _addr) public view returns (uint256) {
        return deposits[_addr];
    }

    function transfer(address _to, uint256 _value) public {
        require(whiteList.isPaidUntil(msg.sender, now));
        require(deposits[msg.sender] >= _value);
        deposits[msg.sender] = deposits[msg.sender].sub(_value);
        deposits[_to] = deposits[_to].add(_value);
    }

    function isPaidUntil(address _addr, uint256 _time) public view returns (bool) {
        return whiteList.isPaidUntil(_addr, _time);
    }

    function _ethDeposit() internal {
        require(now < presaleEndTime);
        deposits[msg.sender] = deposits[msg.sender].add(msg.value);
    }

    function _ethRefund(address _addr, uint256 _value) internal {
        require(now > presaleEndTime);
        require(deposits[_addr] >= _value);
        deposits[_addr] = deposits[_addr].sub(_value);
        _addr.transfer(_value);
    }
}