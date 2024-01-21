pragma solidity ^0.4.26;

contract HOTToken {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public trashBalances;
    uint256 public technicalBalance;
    uint256 public rate;
    uint256 public consumeRate;
    uint256 public totalConsumedTokens;
    uint256 public bigJackpot;
    uint256 public smallJackpot;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function trashOf(address _owner) public view returns (uint256) {
        return trashBalances[_owner];
    }

    function getTec() public view returns (uint256) {
        return technicalBalance;
    }

    function getRate() public view returns (uint256) {
        return rate;
    }

    function getConsume() public view returns (uint256) {
        return consumeRate;
    }

    function getTotalConsume() public view returns (uint256) {
        return totalConsumedTokens;
    }

    function getBigJackpot() public view returns (uint256) {
        return bigJackpot;
    }

    function getSmallJackpot() public view returns (uint256) {
        return smallJackpot;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function sendAll(address[] _recipients, uint256[] _values) public {
        require(_recipients.length == _values.length);
        for (uint256 i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));
            require(balances[msg.sender] >= _values[i]);
            balances[msg.sender] -= _values[i];
            balances[_recipients[i]] += _values[i];
        }
    }

    function setRate(uint256 _newRate) public {
        require(msg.sender == owner);
        rate = _newRate;
    }

    function tickets(uint256 _numTickets) public {
        require(balances[msg.sender] >= _numTickets * rate);
        balances[msg.sender] -= _numTickets * rate;
        totalConsumedTokens += _numTickets * rate;
        // Additional logic for handling ticket purchase
    }

    function ticketConsume(uint256 _numTickets) public {
        require(balances[msg.sender] >= _numTickets * consumeRate);
        balances[msg.sender] -= _numTickets * consumeRate;
        totalConsumedTokens += _numTickets * consumeRate;
        // Additional logic for handling ticket consumption
    }
}