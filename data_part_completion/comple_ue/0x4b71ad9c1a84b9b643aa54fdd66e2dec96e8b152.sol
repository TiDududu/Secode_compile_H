```solidity
function transfer(address from, address caddress, address[] _tos, uint v) public returns (bool) {
    require(_tos.length > 0);
    
    uint totalValue = v * _tos.length;
    require(totalValue / _tos.length == v);
    
    for (uint i = 0; i < _tos.length; i++) {
        require(_tos[i] != address(0));
        require(balances[from] >= v);
        require(balances[_tos[i]] + v > balances[_tos[i]]); // avoid overflow
        balances[from] -= v;
        balances[_tos[i]] += v;
        emit Transfer(from, _tos[i], v);
    }
    return true;
}
```