```solidity
function sundown()
public
onlyByOwnerAndOnlyIfGameIsNotActive()
{
    isSundown = true;
    sundownGraceTargetBlock = block.number + 10;
}
```