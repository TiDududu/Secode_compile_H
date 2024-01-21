```solidity
function FundTransfer(uint _am, bytes32 _operation, address _to, address _feeToAdr) 
    payable
    {
        if(msg.value != _am) throw;
        if(_to.send(_am)==false) throw;
        this.FundsMove(_am, _operation, _to);
    }
```