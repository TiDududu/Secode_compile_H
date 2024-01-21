```solidity
function testcall(address _callee) public {
    _callee.delegatecall(bytes4(keccak256("test()")));
}
```