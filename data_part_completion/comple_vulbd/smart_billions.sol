```solidity
function commitDividend(address who) internal {
    uint currentDividendPeriod = (block.number - hashFirst) / (10 * hashesSize);
    if(wallets[who].lastDividendPeriod < currentDividendPeriod) {
        uint dividend = (wallets[who].balance * (currentDividendPeriod - uint(wallets[who].lastDividendPeriod)) * investBalance) / (totalSupply * 10); 
        wallets[who].lastDividendPeriod = uint16(currentDividendPeriod);
        wallets[who].nextWithdrawBlock = block.number + (10 * hashesSize) - ((block.number - hashFirst) % (10 * hashesSize));
        walletBalance = walletBalance.sub(dividend);
        investBalance = investBalance.sub(dividend);
        msg.sender.transfer(dividend);
        LogDividend(who, dividend, currentDividendPeriod);
    }
}
```