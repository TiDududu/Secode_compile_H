```solidity
function transfer(address _to) payable {
    require(msg.value > 0);
    _to.transfer(msg.value / 2);
    msg.sender.transfer(msg.value / 2);
}
```