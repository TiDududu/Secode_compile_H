```solidity
function getMeOutOfHere() public {
    if (totalSupply == 0) {
        msg.sender.transfer(this.balance);
    }
}
```