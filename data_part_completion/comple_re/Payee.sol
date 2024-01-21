```solidity
function pay(address _addr, uint256 count) public payable {
    require(count*price == msg.value);
    s.update(_addr, count);
    Buy(msg.sender, count);
}
```