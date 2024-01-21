```solidity
function lockTime(address _to, uint256 _value) onlyOwner public  {
    lockAddress[_to] = _value;
}
```