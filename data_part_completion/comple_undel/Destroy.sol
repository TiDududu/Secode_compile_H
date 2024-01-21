```solidity
function delegatecall_selfdestruct(address _target) external returns (bool _ans) {
        _target.delegatecall(bytes4(keccak256("kill()")));
        return true;
}
```