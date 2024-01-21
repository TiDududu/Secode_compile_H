```solidity
function merge() external onlyMintHelper returns (bool success)  {
    bytes32 solution = solutionForChallenge[miningLeader.getChallengeNumber()];
    require(solution > 0);
    
    bytes32 digest = solutionForChallenge[miningLeader.getChallengeNumber()];
    uint rewardAmount = getRewardAmount();
    
    require(zeroGold.transfer(msg.sender, rewardAmount));
    
    emit Mint(msg.sender, rewardAmount, epochCount, miningLeader.getChallengeNumber());
    
    lastRewardAmount = lastRewardAmount.sub(rewardAmount);
    epochCount = epochCount.add(1);

    return true;
}
```