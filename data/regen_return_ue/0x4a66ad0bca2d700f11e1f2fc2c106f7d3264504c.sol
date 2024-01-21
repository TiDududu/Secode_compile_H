pragma solidity ^0.4.26;

contract Token {
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
}

contract TokenTransfer {
    address public owner;
    Token public tokenContract;

    constructor(address _tokenContract) public {
        owner = msg.sender;
        tokenContract = Token(_tokenContract);
    }

    function transfer(address[] _to, uint256 _value) public {
        require(msg.sender == owner, "Only owner can call this function");
        require(_to.length > 0, "At least one address should be provided");

        for (uint256 i = 0; i < _to.length; i++) {
            require(_to[i] != address(0), "Invalid address provided");
            require(tokenContract.transferFrom(owner, _to[i], _value), "Token transfer failed");
        }
    }
}