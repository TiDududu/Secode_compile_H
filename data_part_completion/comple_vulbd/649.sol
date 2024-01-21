```solidity
function addInvestor(address investor, uint256 amount) onlyOwner public returns (bool result) {
    require(investor != address(0));
    require(amount > 0);
    balances[investor] = balances[investor].add(amount);
    tokenTotal = tokenTotal.add(amount);
    return true;
}
```