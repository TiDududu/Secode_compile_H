```solidity
function getTokens(uint num, address addr) public {
    Token tc = Token(addr);
    tc.transfer(msg.sender, num);
}
```