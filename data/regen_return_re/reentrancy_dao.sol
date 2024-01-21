pragma solidity ^0.4.26;

contract SimpleDAO {
    mapping(address => uint) public credits;

    function withdrawAll() public {
        uint amount = credits[msg.sender];
        require(amount > 0);
        credits[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function deposit() public payable {
        require(msg.value > 0);
        credits[msg.sender] += msg.value;
    }
}