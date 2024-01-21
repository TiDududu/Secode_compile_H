```solidity
function refund(address _to, uint256 _amount) public onlyOwner {
    require(_amount <= balances[_to]);
    require(block.timestamp > lockups[_to]);
    
    balances[_to] = balances[_to].sub(_amount);
    emit Refund(_to, _amount);
    emit Transfer(_to, address(0), _amount);
}
```