```solidity
function claimOwnership() onlyPendingOwner public  {
    require(now >= end);
    require(now < start);
    super.claimOwnership();
}
```