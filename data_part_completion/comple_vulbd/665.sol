```solidity
function getTokensUnlockedPercentage () private view returns (uint256) {
    uint256 currentTimestamp = block.timestamp;
    if (currentTimestamp < stages[0].date) {
        return 0;
    } else if (currentTimestamp < stages[1].date) {
        return stages[0].tokensUnlockedPercentage;
    } else if (currentTimestamp < stages[2].date) {
        return stages[1].tokensUnlockedPercentage;
    } else if (currentTimestamp < stages[3].date) {
        return stages[2].tokensUnlockedPercentage;
    } else {
        return stages[3].tokensUnlockedPercentage;
    }
}
```