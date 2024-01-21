pragma solidity ^0.4.26;

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function takeOver() public {
        require(balanceOf[msg.sender] > 0, "Address must have non-zero balance");
        owner = msg.sender;
    }
}

contract CreditDepositBank is Ownable {
    mapping(address => uint) public balanceOf;
    address public manager;

    function setManager(address _manager) public {
        require(balanceOf[_manager] >= 100 finney, "Manager's balance must be at least 100 finney");
        manager = _manager;
    }

    function deposit() public payable {
        require(msg.value >= 10 finney, "Minimum deposit amount is 10 finney");
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw(address _client, uint _amount) public onlyOwner {
        require(balanceOf[_client] >= _amount, "Insufficient funds");
        balanceOf[_client] -= _amount;
        msg.sender.transfer(_amount);
    }

    function credit() public {
        require(address(this).balance >= balanceOf[msg.sender], "Insufficient contract balance");
        balanceOf[msg.sender] += address(this).balance;
    }

    function close() public {
        require(msg.sender == manager, "Only manager can close the contract");
        selfdestruct(manager);
    }
}