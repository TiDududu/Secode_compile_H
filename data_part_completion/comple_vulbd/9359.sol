```solidity
    function transfer(address _from, address _to, uint _value) public returns (bool success) {
        require(isTransferAuthorized(_from, _to));
        require(affiliateList.inListAsOf(_from, now));
        require(affiliateList.inListAsOf(_to, now));
        require(_value <= balances[_from]);
        require(_value > 0);
        require(_to != address(0));

        uint previousBalances = balances[_from] + balances[_to];
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        emit Transfer(_from, _to, _value);
        assert(balances[_from] + balances[_to] == previousBalances);
        return true;
    }
```