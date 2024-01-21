
```solidity
  contractToReceiver[_contractAdd] = _to;
  }

  function spend(address _from, uint256 _value) external returns (bool) {
    require(msg.sender == contractToReceiver[msg.sender]);
    require(_value <= balances[_from]);

    balances[_from] = balances[_from].sub(_value);
    balances[msg.sender] = balances[msg.sender].add(_value);
    emit Transfer(_from, msg.sender, _value);
    return true;
  }
}
```