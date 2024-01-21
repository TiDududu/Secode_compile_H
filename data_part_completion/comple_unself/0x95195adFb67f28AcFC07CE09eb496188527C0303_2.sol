```solidity
        return true;
    }

    /**
     * @dev decreases current allowance
     *
     * @param _spender address who is allowed to spend
     * @param _subtractedValue the no of tokens subtracted from previous allowance
     * @return true if everything goes well
     */
    function decreaseApproval(address _spender, uint _subtractedValue)
        public
        unfreezed(_spender)
        unfreezed(msg.sender)
        noEmergencyFreeze()
        returns (bool success)
    {
        require(_spender != msg.sender, "Can not approve to self");
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue >= oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function _transfer223(address _from, address _to, uint _value, bytes memory _data)
        private
    {
        require(_to != address(0), "Zero address not allowed");
        require(balances[_from] >= _value, "Insufficient balance");
        require(!frozen[_from], "Sender account is frozen");
        require(!frozen[_to], "Receiver account is frozen");

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(_from, _to, _value, _data);

        if (isContract(_to)) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(_from, _value, _data);
        }
    }
}
```