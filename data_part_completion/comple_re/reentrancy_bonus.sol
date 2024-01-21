```solidity
function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0);
        uint amount = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        recipient.transfer(amount);
    }
```