pragma solidity ^0.4.26;

contract TokenSale {
    mapping(address => uint) public balances;
    uint public tokenPrice = 0.001 ether;
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function isComplete() public view returns(bool) {
        return address(this).balance < 1 ether;
    }
    
    function buy(uint _numTokens) public payable {
        require(msg.value == _numTokens * tokenPrice, "Insufficient ether sent");
        balances[msg.sender] += _numTokens;
    }
    
    function sell(uint _numTokens) public {
        require(balances[msg.sender] >= _numTokens, "Insufficient tokens to sell");
        uint saleValue = _numTokens * tokenPrice;
        balances[msg.sender] -= _numTokens;
        msg.sender.transfer(saleValue);
    }
}