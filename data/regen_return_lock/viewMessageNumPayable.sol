pragma solidity ^0.4.26;

contract MessageContract {
    address owner;
    string public message;
    string public message2;
    uint public specialNumber;
    mapping(address => uint) public etherSent;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function setNewMessage(string newMsg) public payable {
        message = newMsg;
        etherSent[msg.sender] = msg.value;
    }

    function setNewMessageNumber(string m, uint num) public payable onlyOwner {
        require(msg.value >= 1 ether, "Sent value must be greater than or equal to 1 ether");
        message = m;
        specialNumber = num;
        etherSent[msg.sender] = msg.value;
    }

    function setNewMessageNumber2(string m, uint num) public onlyOwner {
        message = m;
        specialNumber = num;
    }

    function setNewMessage2(string meg) public payable onlyOwner {
        message2 = meg;
        etherSent[msg.sender] = msg.value;
    }

    function getMessage() public view returns (string) {
        return message;
    }

    function getMessage2() public view returns (string) {
        return message2;
    }

    function getSpecialNum() public view returns (uint) {
        return specialNumber;
    }
}