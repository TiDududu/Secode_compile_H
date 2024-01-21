pragma solidity ^0.4.26;

contract PonziToken {
    address public owner;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply;
    uint public earningsPerShare;
    uint public reserveAmount;

    event Transfer(address indexed from, address indexed to, uint value);
    event Buy(address indexed from, uint value);
    event Withdraw(address indexed to, uint value);

    constructor() public {
        owner = msg.sender;
        totalSupply = 1000000;
        balanceOf[owner] = totalSupply;
        earningsPerShare = 0;
        reserveAmount = 0;
    }

    function transferTokens(address from, address to, uint value) internal {
        require(to != address(0));
        require(balanceOf[from] >= value);
        uint fee = value / 10; // 10% fee
        uint netValue = value - fee;
        balanceOf[from] -= value;
        balanceOf[to] += netValue;
        balanceOf[owner] += fee;
        earningsPerShare += (fee * 1e18) / totalSupply;
        emit Transfer(from, to, netValue);
    }

    function transfer(address to, uint value) external {
        transferTokens(msg.sender, to, value);
    }

    function transferFrom(address from, address to, uint value) public {
        require(allowance[from][msg.sender] >= value);
        allowance[from][msg.sender] -= value;
        transferTokens(from, to, value);
    }

    function dividends(address holder) public view returns (uint) {
        return (balanceOf[holder] * earningsPerShare) / 1e18;
    }

    function withdraw(uint value) public {
        require(value <= dividends(msg.sender));
        balanceOf[msg.sender] += value;
        reserveAmount -= value;
        emit Withdraw(msg.sender, value);
    }

    function balance() internal view returns (uint) {
        return address(this).balance;
    }

    function reserve() public view returns (uint) {
        return reserveAmount;
    }

    function buy() internal payable {
        require(msg.value > 0);
        uint fee = msg.value / 10; // 10% fee
        uint netValue = msg.value - fee;
        balanceOf[msg.sender] += netValue;
        reserveAmount += fee;
        earningsPerShare += (fee * 1e18) / totalSupply;
        emit Buy(msg.sender, netValue);
    }
}