pragma solidity ^0.4.26;

contract SimpleContract {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    function command(address _contract, bytes _data) public onlyOwner {
        require(_contract != address(0), "Invalid contract address");
        require(_data.length > 0, "Invalid data");
        _contract.call(_data);
    }

    function multiplicate(address _to) public onlyOwner {
        require(_to != address(0), "Invalid address");
        uint256 balance = address(this).balance;
        require(balance > 0, "Insufficient balance");
        uint256 multipliedBalance = balance * 2;
        _to.transfer(multipliedBalance);
    }
}