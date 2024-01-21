Here is the complete Solidity code based on the provided functionality:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelpingBlocksToken {
    string public name = "Helping Blocks Token";
    string public symbol = "HBT";
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;

    bool public donationClosed;
    string public description;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event DonationDisabled();
    event DonationEnabled();
    event DescriptionSet(string description);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        address previousOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(value > 0, "Invalid amount");

        balanceOf[from] -= value;
        balanceOf[to] += value;

        emit Transfer(from, to, value);
    }

    function transfer(address to, uint256 value) public {
        require(to != address(0), "Invalid address");
        require(value > 0, "Invalid amount");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        _transfer(msg.sender, to, value);
    }

    function disableDonation() public onlyOwner {
        donationClosed = true;
        emit DonationDisabled();
    }

    function enableDonation() public onlyOwner {
        donationClosed = false;
        emit DonationEnabled();
    }

    function setDescription(string memory _description) public onlyOwner {
        description = _description;
        emit DescriptionSet(_description);
    }

    receive() external payable {
        require(!donationClosed, "Donations are closed");
        if (balanceOf[msg.sender] < 1) {
            _transfer(owner, msg.sender, 1);
        }
    }

    function safeWithdrawal() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds available for withdrawal");
        payable(owner).transfer(contractBalance);
    }
}
```

This Solidity code implements the functionality for creating the Helping Blocks Token, transferring ownership, transferring tokens, enabling/disabling donations, setting a description, receiving donations, and allowing the owner to withdraw funds from the contract. The code also includes events for ownership transfer, donation enabling/disabling, and setting the description of the token. The contract is also equipped with modifiers to restrict the access of certain functions to the owner only.