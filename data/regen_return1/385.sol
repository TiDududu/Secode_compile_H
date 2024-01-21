pragma solidity ^0.4.26;

contract Token {
    address public owner;
    string public description;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    bool public donationEnabled;

    event Transfer(address indexed from, address indexed to, uint value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event DonationEnabled();
    event DonationDisabled();

    constructor() public {
        owner = msg.sender;
        description = "Initial Token";
        totalSupply = 1000000;
        balanceOf[owner] = totalSupply;
        donationEnabled = true;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner);
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function _transfer(address from, address to, uint value) internal {
        require(to != address(0));
        require(balanceOf[from] >= value);
        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
    }

    function transfer(address to, uint value) public {
        require(msg.sender == owner);
        _transfer(owner, to, value);
    }

    function disableDonation() public {
        require(msg.sender == owner);
        require(donationEnabled);
        donationEnabled = false;
        emit DonationDisabled();
    }

    function enableDonation() public {
        require(msg.sender == owner);
        require(!donationEnabled);
        donationEnabled = true;
        emit DonationEnabled();
    }

    function setDescription(string newDescription) public {
        require(msg.sender == owner);
        description = newDescription;
    }

    function() public payable {
        require(donationEnabled);
        uint tokenAmount = msg.value * 10; // 1 Ether = 10 tokens
        _transfer(owner, msg.sender, tokenAmount);
    }

    function safeWithdrawal() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }
}