```solidity
function upgrade(IApplication newContract, bytes data) public {
    require(msg.sender == owner);
    currentContract = newContract;
    newContract.initialize(data);
    Upgrade(address(newContract), data);
}
```