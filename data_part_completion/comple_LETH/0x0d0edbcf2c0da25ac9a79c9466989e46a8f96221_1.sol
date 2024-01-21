```solidity
function withdrawFunds(address receiver, uint withdrawAmount) external onlyOwner  {
        require(withdrawAmount <= address(this).balance, "Insufficient balance");
        receiver.transfer(withdrawAmount);
}
```