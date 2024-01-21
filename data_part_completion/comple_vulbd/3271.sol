```solidity
function party() public  {
        require(now >= partyTime);
        uint amount = hodlers[msg.sender];
        require(amount > 0);
        hodlers[msg.sender] = 0;
        emit Party(msg.sender, amount);
        msg.sender.transfer(amount);
    }
```