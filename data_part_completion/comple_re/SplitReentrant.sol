```solidity
function withdraw_step1(uint256 _money) external {
    require(tokenBalance[msg.sender] >= _money);
    tokenBalance[msg.sender] -= _money;
    msg.sender.call{value: _money}("");
}
```