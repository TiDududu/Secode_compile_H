pragma solidity ^0.4.26;

contract WhuffieManager {
    mapping(address => uint) public positiveWhuffies;
    mapping(address => uint) public negativeWhuffies;

    event PositiveWhuffiesSent(address indexed sender, address indexed recipient, uint amount, string message);
    event NegativeWhuffiesSent(address indexed sender, address indexed recipient, uint amount, string message);

    function sendPositiveWhuffies(address _recipient, uint _amount, string memory _message) public {
        positiveWhuffies[_recipient] += _amount;
        emit PositiveWhuffiesSent(msg.sender, _recipient, _amount, _message);
    }

    function sendNegativeWhuffies(address _recipient, uint _amount, string memory _message) public {
        negativeWhuffies[_recipient] += _amount;
        emit NegativeWhuffiesSent(msg.sender, _recipient, _amount, _message);
    }
}