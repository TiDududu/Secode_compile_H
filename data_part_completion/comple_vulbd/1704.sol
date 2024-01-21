```solidity
function totalInfo () external view returns (bool, bool, address, uint, uint, uint, uint, uint, uint, address)  {
    return (
      startTime > 0,
      potWithdrawn,
      addressOfCaptain,
      totalPot,
      startTime,
      endTime,
      maxTime,
      addedTime,
      MAIN_SCHEME,
      addressOfOwner
    );
}
```