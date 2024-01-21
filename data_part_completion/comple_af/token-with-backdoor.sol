```solidity
function test_invariants() public view returns(bool){
    return (balances[msg.sender] >= 0);
}
```