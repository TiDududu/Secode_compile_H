```solidity
    function removeExpiredName(string _name) public  {
        uint expires = registry[_name].expires;
        require(now > expires);
        removeName(_name);
    }
```