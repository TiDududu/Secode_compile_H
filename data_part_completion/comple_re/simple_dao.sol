```solidity
function withdraw(uint amount) {
    if (credit[msg.sender] >= amount) {
        msg.sender.transfer(amount);
        credit[msg.sender] -= amount;
    }
}
```