```solidity
function withdrawAll() public {
        uint amount = credit[msg.sender];
        require(amount > 0);
        credit[msg.sender] = 0;
        balance -= amount;
        msg.sender.transfer(amount);
    }
```