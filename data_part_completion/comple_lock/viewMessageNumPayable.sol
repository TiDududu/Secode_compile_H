```solidity
function setNewMessage2(string meg) public payable  {
    require(msg.value == price);
    message2 = meg;
    amount += msg.value;
}
```