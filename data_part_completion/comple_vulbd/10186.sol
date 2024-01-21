```solidity
    function releaseAll() public returns (uint tokens)  {
        uint64 head = chains[toKey(msg.sender, 0)];
        uint totalReleased;
        while (head != 0) {
            bytes32 currentKey = toKey(msg.sender, head);
            uint amount = freezings[currentKey];
            totalReleased += amount;
            delete freezings[currentKey];
            chains[toKey(msg.sender, 0)] = chains[currentKey];
            delete chains[currentKey];
            head = chains[toKey(msg.sender, 0)];
        }
        balances[msg.sender] = balances[msg.sender].add(totalReleased);
        freezingBalance[msg.sender] = 0;
        Released(msg.sender, totalReleased);
        return totalReleased;
    }
```