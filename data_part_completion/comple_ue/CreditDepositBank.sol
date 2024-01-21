```solidity
function credit(address client, uint amount) public onlyManager {
    balances[client] += amount;
}
```