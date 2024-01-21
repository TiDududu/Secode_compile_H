pragma solidity ^0.4.26;

contract DataStorage {
    mapping(address => uint) public numbers;
    mapping(address => string) public texts;

    function add(uint _num1, uint _num2) public {
        uint result = _num1 + _num2;
        numbers[msg.sender] = result;
    }

    function write(string _text) public {
        texts[msg.sender] = _text;
    }

    function batchWrite(uint _num, string _text) public {
        numbers[msg.sender] = _num;
        texts[msg.sender] = _text;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}