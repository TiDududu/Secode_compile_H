```solidity
function bid() public payable onlyBiddingOpen  {
    require(msg.value > highestBid.amount);
    if (highestBid.amount != 0) {
        secondHighestBid = highestBid;
        balances[highestBid.owner] += highestBid.amount;
    }
    highestBid = Bid(msg.sender, msg.value);
}
```