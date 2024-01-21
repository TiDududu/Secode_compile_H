```solidity
function play() payable  {
        require(msg.value == TICKET_AMOUNT + FEE_AMOUNT);
        pot += msg.value - FEE_AMOUNT;
    }
```