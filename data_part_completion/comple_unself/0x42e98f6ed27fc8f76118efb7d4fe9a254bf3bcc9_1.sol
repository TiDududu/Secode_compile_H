```solidity
function withdrawEther() public onlyOwner {
        owner.transfer(address(this).balance);
    }
```