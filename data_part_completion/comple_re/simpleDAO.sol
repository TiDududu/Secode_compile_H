```solidity
function withdraw(uint amount) public {
    require(credit[msg.sender] >= amount);
    credit[msg.sender] -= amount;
    msg.sender.transfer(amount);
}
```