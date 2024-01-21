pragma solidity ^0.4.26;

contract MyTestWallet7 {
    address public owner;
    uint public goal;
    string public recoveryPassword;
    address public recoveryAddress;

    constructor(uint _goal) public {
        owner = msg.sender;
        goal = _goal;
    }

    function deposit() public payable {
        require(msg.value > 0);
    }

    function() public payable {
        deposit();
    }

    function withdraw() public noone_else {
        require(address(this).balance >= goal);
        msg.sender.transfer(address(this).balance);
    }

    modifier noone_else {
        require(msg.sender == owner);
        _;
    }

    function recovery(string _password, address _returnAddress) public {
        require(keccak256(abi.encodePacked(_returnAddress)) == keccak256(abi.encodePacked(recoveryAddress)));
        selfdestruct(_returnAddress);
    }
}