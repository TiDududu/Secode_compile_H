```solidity
function Collect(uint _am)
public
payable
{
    require(Bal[msg.sender]>=_am); 
    Bal[msg.sender]-=_am;
    msg.sender.transfer(_am);
}
```