```solidity
function withdrawFunds (uint256 _weiToWithdraw) public {
    require(_weiToWithdraw <= withdrawalLimit);
    require(_weiToWithdraw <= balances[msg.sender]);
    require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

    msg.sender.transfer(_weiToWithdraw);
    balances[msg.sender] -= _weiToWithdraw;
    lastWithdrawTime[msg.sender] = now;
}
```