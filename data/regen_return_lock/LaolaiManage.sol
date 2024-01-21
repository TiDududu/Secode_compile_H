pragma solidity ^0.4.26;

contract LoanDefaultManagement {
    address public owner;
    mapping(bytes32 => uint) public defaulters;

    constructor() public {
        owner = msg.sender;
    }

    function addLaolai(bytes32 idCard, uint value) public {
        require(msg.sender == owner, "Only owner can add defaulters");
        defaulters[idCard] = value;
    }

    function judgeLaolai(bytes32 idCard) public payable returns (bool) {
        require(msg.value >= 0.1 ether, "Insufficient payment");
        if (defaulters[idCard] > 0) {
            msg.sender.transfer(msg.value);
            return true;
        } else {
            return false;
        }
    }

    function hello() public pure returns (string) {
        return "hello";
    }
}