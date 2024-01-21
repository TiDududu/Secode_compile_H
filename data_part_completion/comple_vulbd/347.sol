```solidity
  function hasOpened() public view returns (bool)  {
    return block.timestamp >= openingTime;
  }
```