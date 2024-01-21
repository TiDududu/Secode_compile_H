```solidity
function proxyCall(address _to, bytes _data) external {
    assembly {
      let result := delegatecall(gas, _to, add(_data, 0x20), mload(_data), 0, 0)
      let size := returndatasize
      let ptr := mload(0x40)
      returndatacopy(ptr, 0, size)
      switch result
      case 0 {revert(ptr, size)}
      default {return(ptr, size)}
    }
  }
```