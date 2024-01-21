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

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        owner = newOwner;
    }
}

contract ReferStorage is Ownable {
    mapping(address => uint256) public referralBalances;
    mapping(address => bool) public whitelist;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwnerOrWhitelist() {
        require(msg.sender == owner || whitelist[msg.sender]);
        _;
    }

    modifier onlyParentContract() {
        require(msg.sender == owner || msg.sender == address(this));
        _;
    }
}