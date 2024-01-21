pragma solidity ^0.4.26;

contract Token {
    mapping(address => uint) public balances;

    function transfer(address to, uint amount) public returns(bool) {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        return true;
    }
}

contract TokenTransfer {
    Token public token;

    constructor(address tokenAddress) public {
        token = Token(tokenAddress);
    }

    function transfer(address to, uint amount) public returns(bool) {
        require(token.transfer(to, amount));
        return true;
    }
}