```solidity
 stop(bool destruct) external onlyOwner  {
        if (destruct) {
            selfdestruct(owner1);
        } else {
            stopped = true;
        }
    }
```