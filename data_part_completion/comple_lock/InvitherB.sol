```solidity
function addUser(int256 parent_id) public payable isUnlocked {
  require(msg.value >= price);
  int256 newUserId = _addUser(msg.sender);
  int256 rewarder = getRewarder(parent_id);
  address rewardAddress = usersMap[rewarder].user_address;
  if (_addrNotNull(rewardAddress)) {
    rewardAddress.transfer(price);
    emit Reward(rewardAddress, rewarder, price);
  }
  emit AddUser(msg.sender, newUserId);
}
```