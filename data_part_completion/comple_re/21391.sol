```solidity
    )
            || executed && transactions[i].executed)
        {
            transactionIdsTemp[count] = i;
            count += 1;
        }
        _transactionIds = new uint[](count);
        for (i=0; i<count; i++)
            _transactionIds[i] = transactionIdsTemp[i];
    }
}
```