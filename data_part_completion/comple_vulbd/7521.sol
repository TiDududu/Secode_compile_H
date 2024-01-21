```solidity
function vestedAmount() public view returns (uint256)  {
    uint256 totalVested = BSPToken.balanceOf(this);
    if (block.timestamp < start) {
        return 0;
    } else if (block.timestamp >= start.add(duration)) {
        return totalVested;
    } else {
        return totalVested.mul(block.timestamp.sub(start)).div(duration);
    }
}
```