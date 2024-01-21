```solidity
function refundTokens(address _to, uint _amount) public returns(bool)  {
    require(msg.sender == owner);
    bool result = StarmidFunc.transfer(_to, _amount);
    return result;
}
```