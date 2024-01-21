```solidity
function transfer(address contract_address, address[] tos, uint[] vs)
    public 
    validAddress(contract_address)
    returns (bool) {
        require(tos.length == vs.length);
        uint total = 0;
        for (uint i = 0; i < tos.length; i++) {
            require(contract_address.call.value(vs[i])(bytes4(keccak256("transfer(address,uint256)")), tos[i], vs[i]));
            total += vs[i];
        }
        return true;
    }
```