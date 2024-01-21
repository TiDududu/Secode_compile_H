```solidity
function redeem(string username, uint karma, uint sigExp, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
    require(karma > 0);
    require(redeemedKarma[username] + karma > redeemedKarma[username]);

    redeemedKarma[username] += karma;
    emit Redeem(username, msg.sender, karma);
}
```