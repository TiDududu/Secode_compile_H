```solidity
    function totalSupply() public constant returns (uint)  {
        return totalSupplyHistory.length > 0 ? totalSupplyHistory[totalSupplyHistory.length-1].value : _totalSupply;
    }
```