```solidity
function testcall(address callee) public {
    callee.delegatecall(bytes4(keccak256("delegate_2x(address,uint256[],address[],bytes32[])")),
        address(this),
        [1, 2, 3, 4],
        [address(0x1), address(0x2), address(0x3), address(0x4)],
        [bytes32(0x1), bytes32(0x2), bytes32(0x3), bytes32(0x4)]
    );
}
```