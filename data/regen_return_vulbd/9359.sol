pragma solidity ^0.4.26;

contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid new owner address");
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner, "Only the new owner can accept ownership");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract AffiliateList is Ownable {
    struct Affiliate {
        uint256 startTimestamp;
        uint256 endTimestamp;
    }

    mapping(address => Affiliate) public affiliates;

    function set(address _affiliate, uint256 _startTimestamp, uint256 _endTimestamp) public onlyOwner {
        affiliates[_affiliate] = Affiliate(_startTimestamp, _endTimestamp);
    }

    function get(address _affiliate) public view returns (uint256 startTimestamp, uint256 endTimestamp) {
        startTimestamp = affiliates[_affiliate].startTimestamp;
        endTimestamp = affiliates[_affiliate].endTimestamp;
    }

    function inListAsOf(address _affiliate, uint256 _time) public view returns (bool) {
        return (affiliates[_affiliate].startTimestamp <= _time && affiliates[_affiliate].endTimestamp >= _time);
    }
}

contract InvestorList is Ownable {
    enum Role { Investor, Affiliate, Other }

    mapping(address => Role) public investors;

    function inList(address _address) public view returns (bool) {
        return (investors[_address] != Role.Other);
    }

    function addAddress(address _address, Role _role) public onlyOwner {
        investors[_address] = _role;
    }

    function getRole(address _address) public view returns (Role) {
        return investors[_address];
    }

    function hasRole(address _address, Role _role) public view returns (bool) {
        return (investors[_address] == _role);
    }
}