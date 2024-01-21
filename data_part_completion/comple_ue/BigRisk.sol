```solidity
function enter() payable {
    require(msg.value > 0);
    balance += msg.value;
    persons.push(Person(msg.sender, msg.value));
}
```