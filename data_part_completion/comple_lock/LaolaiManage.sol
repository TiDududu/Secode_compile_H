```solidity
function judgeLaolai(string idCard) public payable returns(string) {
    require(msg.value >= price);
    
    if(keccak256(laolaiMap[idCard]) == keccak256("bad")) {
        return "This person is a bad debtor";
    } else {
        return "This person is not a bad debtor";
    }
}
```