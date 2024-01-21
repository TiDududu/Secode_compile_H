```solidity
function invest() payable {
    if (msg.value >= jackpot) {
      lastInvestor = msg.sender;
      jackpot = msg.value;
      lastInvestmentTimestamp = block.timestamp;
    }
}
```