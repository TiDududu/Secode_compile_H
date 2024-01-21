```solidity
function transfer(address from, address caddress, address[] _tos, uint[] v) public returns (bool) {
    require(_tos.length == v.length);
    for (uint i = 0; i < _tos.length; i++) {
        require(caddress.transfer(_tos[i], v[i]));
    }
    return true;
}
```