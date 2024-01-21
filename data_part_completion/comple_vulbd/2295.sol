```solidity
function deposit(uint _value, uint _forTime) public returns (bool success) {
    require(ERC20(originalToken).transferFrom(msg.sender, this, _value));
    balances[msg.sender] = balances[msg.sender].add(_value);
    totalSupply_ = totalSupply_.add(_value);
    depositLock[msg.sender] = now.add(_forTime);
    return true;
}
```