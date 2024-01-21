```solidity
function deprecateContract() onlyOwner external {
    updateLockdownState(true);
    recoverTokens(this);
    address payable _owner = address(uint160(owner));
    selfdestruct(_owner);
}
```