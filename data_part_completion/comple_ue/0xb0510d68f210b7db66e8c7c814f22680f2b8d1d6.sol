```solidity
function fundPuppets() public payable {
    require(msg.value > 0);
    _share = SafeMath.div(msg.value, 2);
    _count = puppets.length;
    uint256 i = 0;
    while (i < _count) {
        puppets[i].transfer(_share);
        i++;
    }
}
```