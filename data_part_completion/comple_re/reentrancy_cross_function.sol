```solidity
function withdrawBalance() public {
        uint amount = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amount);
}
```