pragma solidity ^0.4.26;

contract HodlEthereum {
    mapping(address => uint) public hodlerBalance;
    
    event Hodl(address hodler, uint amount);
    event Party(address hodler, uint amount);
    
    function hodl() public payable {
        require(msg.value > 0);
        hodlerBalance[msg.sender] += msg.value;
        emit Hodl(msg.sender, msg.value);
    }
    
    function party(uint partyTime) public {
        require(block.timestamp >= partyTime);
        require(hodlerBalance[msg.sender] > 0);
        
        uint amount = hodlerBalance[msg.sender];
        hodlerBalance[msg.sender] = 0;
        msg.sender.transfer(amount);
        emit Party(msg.sender, amount);
    }
}