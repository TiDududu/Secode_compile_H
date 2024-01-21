```solidity
function buy() payable {
    uint amount = msg.value / 1 ether; 
    balances[msg.sender] += amount;
}
```