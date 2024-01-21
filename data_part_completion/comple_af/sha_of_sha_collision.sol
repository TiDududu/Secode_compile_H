```solidity
function check(uint x) {
        require(m[keccak256(abi.encodePacked("A", x))] == 1);
}
```