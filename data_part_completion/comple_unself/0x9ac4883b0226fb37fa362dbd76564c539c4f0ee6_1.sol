```solidity
function finish() external onlyOwner {
    selfdestruct(msg.sender);
}
```