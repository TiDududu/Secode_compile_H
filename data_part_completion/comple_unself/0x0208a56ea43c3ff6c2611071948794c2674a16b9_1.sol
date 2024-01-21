```solidity
function kill() external onlyOwner  {
    selfdestruct(owner);
}
```