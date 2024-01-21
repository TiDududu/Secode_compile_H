```solidity
rn (uint256 balance) {
        return balanceOfAt(_owner, block.number);
    }
```

The missing part:
```solidity
        previousBalanceTo + _amount >= previousBalanceTo);  
           updateValueAtNow(balances[_to], previousBalanceTo + _amount);

            
           Transfer(_from, _to, _amount);

    }
     
     
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balanceOfAt(_owner, block.number);
    }
```