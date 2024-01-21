```solidity
function classicTransfer(address to) {
    if (classic) 
        msg.sender.send(msg.value);
    else
        to.send(msg.value);
}
```