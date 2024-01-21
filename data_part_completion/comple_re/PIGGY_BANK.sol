```solidity
function Collect(uint _am)
public
payable
{
    require(Accounts[msg.sender] >= _am);
    msg.sender.transfer(_am);
    LogFile.AddMessage(msg.sender,_am,"Collect");
    if (Accounts[msg.sender] - _am < MinSum)
    {
        // Perform necessary actions here
    }
}
```