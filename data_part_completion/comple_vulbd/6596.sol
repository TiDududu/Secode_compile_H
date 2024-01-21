```solidity
    function freezeTo(address _to, uint _amount, uint64 _until) public {
        require(_until > block.timestamp);
        bytes32 key = toKey(_to, _until);
        bytes32 parentKey = toKey(_to, uint64(0));
        uint64 next = chains[parentKey];

        if (next == 0) {
            chains[parentKey] = _until;
            freezings[key] = _amount;
            freezingBalance[_to] = freezingBalance[_to].add(_amount);
            emit Freezed(_to, _until, _amount);
            return;
        }

        bytes32 nextKey = toKey(_to, next);
        uint parent;

        while (next != 0 && _until > next) {
            parent = next;
            parentKey = nextKey;

            next = chains[nextKey];
            nextKey = toKey(_to, next);
        }

        if (_until == next) {
            freezings[nextKey] = freezings[nextKey].add(_amount);
            freezingBalance[_to] = freezingBalance[_to].add(_amount);
            emit Freezed(_to, _until, _amount);
            return;
        }

        if (next != 0) {
            chains[key] = next;
            chains[parentKey] = _until;
            freezings[key] = _amount;
            freezingBalance[_to] = freezingBalance[_to].add(_amount);
            emit Freezed(_to, _until, _amount);
            return;
        }

        chains[key] = 0;
        chains[parentKey] = _until;
        freezings[key] = _amount;
        freezingBalance[_to] = freezingBalance[_to].add(_amount);
        emit Freezed(_to, _until, _amount);
    }
```