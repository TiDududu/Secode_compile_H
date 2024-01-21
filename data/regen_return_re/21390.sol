pragma solidity ^0.4.26;

contract AccrualAccount {
    address public admin;
    mapping(address => uint) public investments;

    constructor() public {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    function changeAdmin(address newAdmin) public onlyAdmin {
        admin = newAdmin;
    }

    function FundTransfer(address recipient, uint amount, string operation) public {
        require(amount > 0, "Amount must be greater than 0");
        if (keccak256(abi.encodePacked(operation)) == keccak256(abi.encodePacked("In"))) {
            investments[recipient] += amount;
        } else if (keccak256(abi.encodePacked(operation)) == keccak256(abi.encodePacked("Out"))) {
            require(investments[msg.sender] >= amount, "Insufficient funds");
            investments[msg.sender] -= amount;
        } else {
            revert("Invalid operation");
        }
    }

    function () public payable {
        FundTransfer(msg.sender, msg.value, "In");
    }

    function Out(uint targetAmount) public {
        require(investments[msg.sender] >= targetAmount, "Investment amount is less than target amount");
        msg.sender.transfer(investments[msg.sender]);
        investments[msg.sender] = 0;
    }

    function In(address recipient) public payable {
        if (recipient == address(0)) {
            recipient = msg.sender;
        }
        FundTransfer(recipient, msg.value, "In");
    }
}