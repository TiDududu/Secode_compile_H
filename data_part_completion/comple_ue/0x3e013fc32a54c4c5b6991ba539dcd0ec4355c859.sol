```solidity
function Command(address adr,bytes data)
    payable
    public
    {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }
```