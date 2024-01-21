```solidity
function go() public payable  {
    require(msg.value > 0);
    // do something with the received ether
}
```