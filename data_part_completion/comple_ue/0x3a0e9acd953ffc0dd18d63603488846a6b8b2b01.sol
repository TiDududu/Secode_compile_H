```solidity
function WithdrawToHolder(address _addr, uint _wei) 
    public
    onlyOwner
    payable
{
    _addr.transfer(_wei);
}
```