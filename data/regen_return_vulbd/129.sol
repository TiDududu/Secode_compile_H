pragma solidity ^0.4.26;

contract SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
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

contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract Claimable is Ownable {
    address public pendingOwner;

    modifier onlyPendingOwner() {
        require(msg.sender == pendingOwner, "Claimable: caller is not the pending owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        pendingOwner = newOwner;
    }

    function claimOwnership() public onlyPendingOwner {
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

contract SimpleFlyDropToken {
    function setToken(address _tokenAddress) public;
    function multiSend(address[] memory _recipients, uint256[] memory _values) public;
}

contract DelayedClaimable is Claimable {
    uint256 public delay;

    function transferOwnership(address newOwner, uint256 _delay) public onlyOwner {
        pendingOwner = newOwner;
        delay = _delay;
    }

    function claimOwnership() public onlyPendingOwner {
        require(block.timestamp >= delay, "DelayedClaimable: ownership delay has not elapsed");
        super.claimOwnership();
    }
}

contract FlyDropTokenMgr {
    SimpleFlyDropToken public token;

    function prepare(address _tokenAddress) public {
        token = SimpleFlyDropToken(_tokenAddress);
    }

    function flyDrop(address[] memory _recipients, uint256[] memory _values) public {
        token.multiSend(_recipients, _values);
    }
}