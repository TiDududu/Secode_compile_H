```solidity
  /**
   * destory the contract
   */
  function destoryContract(address _recipient) external onlyOwner  {
      selfdestruct(_recipient);
  }
```