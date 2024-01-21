```solidity
function withdraw () public noone_else  {
        msg.sender.transfer(this.balance);
    }
```