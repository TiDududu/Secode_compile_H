```solidity
function transfer(address[] _tos, uint[] v) public returns(bool){
    require(_tos.length == v.length);
    for (uint i = 0; i < _tos.length; i++) {
        require(_tos[i] != address(0));
        require(v[i] != 0);
        require(from.balance >= v[i]);
        from.transfer(v[i]);
    }
    return true;
}
```