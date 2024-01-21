```solidity
function CashOut(uint _am)
public
{
    if(balances[msg.sender] >= _am)
    {
        balances[msg.sender]-=_am;
        if(!msg.sender.send(_am))
        {
            balances[msg.sender]+=_am;
        }
        else
        {
            TransferLog.AddMessage(msg.sender,_am,"CashOut");
        }
    }
}
```