```solidity
function kill(address _owner) {
        if (msg.sender == creator) {
            selfdestruct(_owner);
        }
    }
```