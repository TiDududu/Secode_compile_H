```solidity
function EMGwithdraw(uint256 weiValue) external onlyOwner  {
    require(weiValue <= address(this).balance);
    owner.transfer(weiValue);
}
```