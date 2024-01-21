```solidity
function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external  {
        if (isFunding) throw;
        isFunding = true;
        fundingStartBlock = _fundingStartBlock;
        fundingStopBlock = _fundingStopBlock;
    }
```